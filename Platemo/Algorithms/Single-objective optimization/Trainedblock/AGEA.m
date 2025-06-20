classdef AGEA < ALGORITHM
    % <2025><single><real>
    methods
        function main(A,P)

            d=load('C06D30.mat');B=d.Blocks;G=d.Graph;e=1e-4;
            isPop=arrayfun(@(s)isa(s,'Block_Population'),B(:)');
            B(isPop).Initialization(P.Initialization());
            f=6e5;l=length(B);B(1,l).Weight(:,1)=rand(size(B(1,l).Weight,1),1);
            w0=B(1,l).Weight(:,1);i=2:size(B(1,l).Weight,2)-1;t=B(1,l).Weight(:,i);
            if rand<0.1,B(1,l).Weight(:,i)=t+e*rand;else,B(1,l).Weight(:,i)=t;end
            persistent s;
            
            while A.NotTerminated(B(1).output)
                a=false(1,l);
                while ~all(a(isPop))
                    for j=find(~a)
                        if all(a(logical(G(:,j)))|isPop(logical(G(:,j))))
                            if j==l
                                if P.FE<=0.1*f
                                    w=(1-0.9*(P.FE/(0.1*f))).*w0;
                                elseif P.FE>0.1*f && P.FE<=0.5*f
                                    w=(0.1-0.09*((P.FE-0.1*f)/(0.4*f))).*w0;
                                elseif P.FE>0.5*f && P.FE<=0.8*f
                                    pr=((P.FE-0.5*f)/(0.3*f));
                                    if rand<=0.5
                                        w=(0.01-0.009*pr).*w0;
                                    else
                                        w=(max((0.01 - 0.01 * pr^2),0)).*w0;
                                    end
                                else
                                    if isempty(s)
                                        s_=0.8+rand*0.1;s=ceil(s_*f);
                                    end
                                    if P.FE>=s,w=0;end
                                end
                                B(1,j).Weight(1:size(B(1,j).Weight,1))=w;
                            end
                            B(j).Main(P,B(logical(G(:,j))),G(:,j));
                            a(j)=true;
                        end
                    end
                end
            end
        end
    end
end