function sid_sa=hyperSIDSAD(t,r)
% t��r ���� Nx1 ����,pΪ���� 'tan' or 'sin'
sa=acos((t'*r)/(norm(t)*norm(r)));   % SA Spectral Angle
tm=t./sum(t);
rm=r./sum(r);
sid=(tm-rm)'*(log10(tm)-log10(rm));

sid_sa=sid*sin(sa);
% elseif(strcmp(p,'sin'))
%     sid_sa=sid*sin(sa);
% else
%     error('You can only use ''tan'' or ''sin''');