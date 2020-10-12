//https://zhuanlan.zhihu.com/p/150365777
class BN;
    rand bit [127:0] num [32:0];
    string name;

    constraint c {num[32]==0;num[0][0]==1;};

    function new(string name="A");
      this.name = name;
    endfunction

    // BN display
    function void BN_display(bit flag=0);
        string s;
        s={s,name,":"};
        if(flag==1)
        s={s,$sformatf("%h",num[32])};
        for (int i=1; i<32+1; i++) begin
        s={s,$sformatf("%h",num[32-i])};
        end
        s={s,"\n"};
        $display(s);
    endfunction : BN_display

    // BN_shift
    function void BN_shift();
        for (int i=0; i<32; i++) begin
        num[i] = num[i+1];
        end
        num[32] = 0;
    endfunction : BN_shift

    // BN_mul
    function void BN_mul(bit [127:0] a,BN ans);
        bit [255:0] temp;
        bit [127:0] carry;
        for (int i = 0; i < 32; i++)
        begin
            temp = num[i] * a + carry;
            ans.num[i] = temp[127:0];
            carry = temp>>128;
        end
        ans.num[32] = carry;
    endfunction : BN_mul

    // BN_add
    function automatic void BN_add(input BN a,b,ref BN c);
        bit [128:0] psum;
        bit carry;
        carry =0;
            for (int i = 0; i < 32+1; i++)
            begin
                psum = a.num[i] + b.num[i]+ carry;
                c.num[i] = psum;
                carry = psum[128];
            end
    endfunction : BN_add

    // BN_com
    function void BN_com(ref BN c);
        BN temp,b;
        temp = new("temp");
        b = new("b");
        for (int i=0; i<32+1; i++) begin
                temp.num[i]=~this.num[i];
                b.num[i]=0;
        end
        b.num[0]=1;
        BN_add(temp,b,c);
    endfunction : BN_com

    // BN_sub
    function automatic void BN_sub(input BN a,b,ref BN c);
        BN com;
        com =new("com");
        b.BN_com(com);
        BN_add(a,com,c);
    endfunction : BN_sub

    // BN_w
    function void BN_w(output bit [127:0] w);
        bit[127:0] t;
        bit[255:0] tt;
        t=1;
        tt=0;
        for (int i=0; i<127; i++) begin
                tt=t*t;
                t=tt[127:0];
                tt=t*num[0];
                t=tt[127:0];
                $display("%h",t);
        end
        tt=0-t;
        w=tt[127:0];
    endfunction

    // BN_cmp return 1 when this >= a
    function bit BN_cmp(input BN a);
        for (int i=0; i<32+1; i++) begin
                if(num[32-i]<a.num[32-i])
                        return 0;
                if(num[32-i]>a.num[32-i])
                        return 1;
        end
        return 1;
    endfunction

    function automatic void mont_mul(input BN x,y,N,ref BN r);
            BN temp1,temp2,temp3;
            bit [127:0] u,w;
            bit [255:0] ut;
            temp1=new("temp1");
            temp2=new("temp2");
            temp3=new("temp3");
            N.BN_w(w);
            $display("%h",w);
            x.BN_display();
            y.BN_display();
            N.BN_display();
            r.BN_display();
            for (int i=0; i<32; i++) begin
                    ut=y.num[i]*x.num[0];
                    u=ut[127:0];
                    ut=r.num[0]+u;
                    u=ut[127:0];
                    ut=u*w;
                    u=ut[127:0];
                    x.BN_mul(y.num[i], temp1);
                    N.BN_mul(u, temp2);
                    BN_add(r, temp1, temp3);
                    BN_add(temp3, temp2, r);
                    r.BN_shift();
            end
            if(r.BN_cmp(N)) begin
                    BN_sub(r,N,temp1);
                    r.num=temp1.num;
            end
            $display("x*y*p^-1 mod N:");
            r.BN_display();
    endfunction : mont_mul

endclass : BN


module mm_sv_sim_model;
    // import BN_pkg::*;

    initial begin
            BN x,y,N,r;
            x=new("x");
            y=new("y");
            N=new("N");
            r=new("r");
            void'(x.randomize());
            void'(y.randomize());
            void'(N.randomize());
            r.mont_mul(x,y,N,r);
    end

endmodule