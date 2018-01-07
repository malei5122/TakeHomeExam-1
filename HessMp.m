function H=HessMp(f,x0,varargin)
f0=feval(f,x0,varargin{:}); 
[T,co]=size(f0);
if co>1; error('Error in HessMp, The function should be a column vector or a scalar'); end

[k,c]=size(x0);
if k<c,
    x0=x0';
end
k=size(x0,1); 

h=0.00001;

H=zeros(k,k);
e=eye(k); 

h2=h/2;
for ii=1:k;
    if x0(ii)>100;
        x0P= x0.*( ones(k,1) +  e(:,ii) *h2 );
        x0N= x0.*( ones(k,1) -  e(:,ii) *h2 );
        Deltaii = x0(ii)*h;
    else
        x0P = x0 +  e(:,ii) *h2;
        x0N = x0 -  e(:,ii) *h2;
        Deltaii = h;
    end
    
    for jj=1:ii
    if x0(jj)>100;
        x0PP = x0P .* ( ones(k,1) +  e(:,jj) *h2 );
        x0PN = x0P .* ( ones(k,1) -  e(:,jj) *h2 );
        x0NP = x0N .* ( ones(k,1) +  e(:,jj) *h2 );
        x0NN = x0N .* ( ones(k,1) -  e(:,jj) *h2 );
        Delta = Deltaii*x0(jj)*h;
    else
        x0PP = x0P  +  e(:,jj) *h2; 
        x0PN = x0P  -  e(:,jj) *h2; 
        x0NP = x0N  +  e(:,jj) *h2; 
        x0NN = x0N  -  e(:,jj) *h2; 
        Delta = Deltaii*h;
    end
    
        fPP = feval(f,x0PP,varargin{:});
        fPN = feval(f,x0PN,varargin{:});
        fNP = feval(f,x0NP,varargin{:});
        fNN = feval(f,x0NN,varargin{:});
        
        H(ii,jj)=(sum(fPP)-sum(fPN)-sum(fNP)+sum(fNN))/Delta;
        H(jj,ii)=H(ii,jj);
    end
end