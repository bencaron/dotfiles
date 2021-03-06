FasdUAS 1.101.10   ��   ��    k             l     �� ��    $  Export iPhoto Comments - Flat       	  l     �� 
��   
.( Creates a text file corresponding to each picture with a comment, containing just the comment. The filenames of the text files correspond to the filenames of the images. So avoid having more than one image with the same filename (taken by two different cameras with similar naming conventions, perhaps). This isn�t a problem for most people, but if it is for you, use the slightly more complex version of the script that duplicates the iPhoto folder hierarchy: <http://www.shearersoftware.com/personal/weblog/2004/01/18/iphoto-4-has-comments-no-more>.    	     l     �� ��   }w Note: this does not remove files in the comments folder when a comment disappears (due to deletion of either the comment or the image). To guard against this, you may want to delete the whole comment folder before rerunning this script. (Using a separate folder rather than storing comment files alongside the image makes this easier; you can flush the whole cache at once.)         l     �� ��    o i Written to work around the fact that iPhoto 4 no longer stores photo comments in the AlbumData.xml file.         l     �� ��    R L by Andrew Shearer, 2004-01-25 <mailto:ashearerw at shearersoftware dot com>         l     ������  ��        l     �� ��      config         l     ��  r         m        / )iPhoto Library - My Comments Cache - Flat     o      ���� (0 commentsfoldername commentsFolderName��         l    ! " ! r     # $ # m    ��
�� boovtrue $ o      ���� 0 stripjpg stripJPG " % whether to strip .JPG extension       % & % l    '�� ' r     ( ) ( m    	��
�� boovtrue ) o      ���� (0 openfolderinfinder openFolderInFinder��   &  * + * l    ,�� , r     - . - m     / /  .comment.txt    . o      ���� &0 commentfilesuffix commentFileSuffix��   +  0 1 0 l    2�� 2 r     3 4 3 m     5 5  N    4 o      ���� *0 requiredalbumprefix requiredAlbumPrefix��   1  6 7 6 l     �� 8��   8   end config    7  9 : 9 l     ������  ��   :  ; < ; l   Z =�� = O    Z > ? > k    Y @ @  A B A l   �� C��   C 5 /return some folder of (path to pictures folder)    B  D E D Z   E F G���� F H    & H H l   % I�� I I   %�� J��
�� .coredoexbool        obj  J n    ! K L K 5    !�� M��
�� 
cfol M o    ���� (0 commentsfoldername commentsFolderName
�� kfrmname L l    N�� N I   �� O��
�� .earsffdralis        afdr O m    ��
�� afdrpdoc��  ��  ��  ��   G I  ) A���� P
�� .corecrel****      � null��   P �� Q R
�� 
kocl Q m   + ,��
�� 
cfol R �� S T
�� 
insh S l  - 2 U�� U I  - 2�� V��
�� .earsffdralis        afdr V m   - .��
�� afdrpdoc��  ��   T �� W��
�� 
prdt W K   5 ; X X �� Y��
�� 
pnam Y o   8 9���� (0 commentsfoldername commentsFolderName��  ��  ��  ��   E  Z [ Z r   F W \ ] \ c   F S ^ _ ^ n   F O ` a ` 5   K O�� b��
�� 
cfol b o   L M���� (0 commentsfoldername commentsFolderName
�� kfrmname a l  F K c�� c I  F K�� d��
�� .earsffdralis        afdr d m   F G��
�� afdrpdoc��  ��   _ m   O R��
�� 
ctxt ] o      ���� (0 commentsfolderpath commentsFolderPath [  e�� e l  X X������  ��  ��   ? m     f f�null     ߀��  "
Finder.app�ذ�P䜙Q �U�`����       )       ��(�PI���� �MACS   alis    r  Macintosh HD               ��&eH+    "
Finder.app                                                       7#���(        ����  	                CoreServices    ��^�      ���h      "      3Macintosh HD:System:Library:CoreServices:Finder.app    
 F i n d e r . a p p    M a c i n t o s h   H D  &System/Library/CoreServices/Finder.app  / ��  ��   <  g h g l     �� i��   i \ Vset commentsFolderPath to POSIX path of (path to pictures folder) & commentsFolderName    h  j k j l     ������  ��   k  l m l l  [q n�� n O   [q o p o k   ap q q  r s r l  an t u t X   an v�� w v k   �i x x  y z y l  � ��� {��   { O Irepeat with thePhoto in (every photo of theAlbum whose comment is not "")    z  | } | l  �g ~  ~ X   �g ��� � � k   �b � �  � � � r   � � � � � c   � � � � � n   � � � � � 1   � ���
�� 
pcom � o   � ����� 0 thephoto thePhoto � m   � ���
�� 
utxt � o      ���� 0 commenttext commentText �  � � � r   � � � � � n   � � � � � 1   � ���
�� 
filn � o   � ����� 0 thephoto thePhoto � o      ���� "0 commentfilename commentFilename �  � � � r   � � � � � n   � � � � � 1   � ���
�� 
ipth � o   � ����� 0 thephoto thePhoto � o      ���� "0 photoexportpath photoExportPath �  � � � r   � � � � � n   � � � � � 1   � ���
�� 
filn � o   � ����� 0 thephoto thePhoto � o      ���� 0 photofilename photoFilename �  � � � Z   � � ����� � o   � ����� 0 stripjpg stripJPG � k   � � �  � � � l  � ��� ���   � %  strip .JPG suffix (optionally)    �  � � � Z   � � � ����� � H   � � � � D   � � � � � o   � ����� "0 commentfilename commentFilename � m   � � � � 
 .JPG    � k   � � � �  � � � R   � ��� ���
�� .ascrerr ****      � **** � b   � � � � � b   � � � � � m   � � � � + %Error: file does not end with .JPG: "    � o   � ����� "0 commentfilename commentFilename � m   � � � �  "   ��   �  ��� � l  � �������  ��  ��  ��  ��   �  � � � r   � � � � � n   � � � � � 7 � ��� � �
�� 
ctxt � m   � �����  � m   � ������� � o   � ����� "0 commentfilename commentFilename � o      ���� "0 commentfilename commentFilename �  ��� � l   ������  ��  ��  ��  ��   �  � � � l �� ���   � < 6 add suffix to comment filename (.txt extension, etc.)    �  � � � r   � � � b   � � � o  	���� "0 commentfilename commentFilename � o  	
���� &0 commentfilesuffix commentFileSuffix � o      ���� "0 commentfilename commentFilename �  � � � l ������  ��   �  � � � Z  ` � ����� � >  � � � o  ���� 0 commenttext commentText � m   � �       � k  \ � �  � � � r  2 � � � I .�� � �
�� .rdwropenshor       file � 4  &�� �
�� 
file � l % ��� � b  % � � � o  !���� (0 commentsfolderpath commentsFolderPath � o  !$���� "0 commentfilename commentFilename��   � �� ���
�� 
perm � m  )*��
�� boovtrue��   � o      ���� 0 f   �  � � � l 3> � � � I 3>�� � �
�� .rdwrseofnull���     **** � o  36���� 0 f   � �� ���
�� 
set2 � m  9:����  ��   � , & truncate file, or old data can remain    �  � � � I ?T�� � �
�� .rdwrwritnull���     **** � o  ?B�� 0 commenttext commentText � �~ � �
�~ 
refn � o  EH�}�} 0 f   � �| ��{
�| 
as   � m  KN�z
�z 
utxt�{   �  ��y � I U\�x ��w
�x .rdwrclosnull���     **** � o  UX�v�v 0 f  �w  �y  ��  ��   �  � � � l aa�u�t�u  �t   �  � � � l aa�s ��s   � h bdo shell script "cp " & photoExportPath & photoFilename & " " & commentsFolderPath & photoFilename    �  � � � l aa�r�q�r  �q   �  � � � l aa�p ��p   � o iset testcommentText to "cp " & photoExportPath & photoFilename & " " & commentsFolderPath & photoFilename    �  � � � l aa�o ��o   � ` Zset f to open for access file (commentsFolderPath & commentFilename) with write permission    �  � � � l aa�n ��n   � = 7set eof f to 0 -- truncate file, or old data can remain    �  �  � l aa�m�m   ( "write testcommentText to f as text      l aa�l�l    close access f     l aa�k�j�k  �j    l aa�i	�i  	 h bdo shell script "cp " & photoExportPath & photoFilename & " " & commentsFolderPath & photoFilename    
�h
 l aa�g�f�g  �f  �h  �� 0 thephoto thePhoto � l  � ��e n   � � 2   � ��d
�d 
ipmr o   � ��c�c 0 thealbum theAlbum�e      photos in album    } �b l hh�a�`�a  �`  �b  �� 0 thealbum theAlbum w l  d v�_ 6  d v 2   d i�^
�^ 
ipal C   l u 1   m q�]
�] 
pnam o   r t�\�\ *0 requiredalbumprefix requiredAlbumPrefix�_   u   albums    s �[ l oo�Z�Y�Z  �Y  �[   p m   [ ^�null     ߀��  d
iPhoto.app�ذ  �Q �U�t����       )       ��(�PI���� �iPho   alis    L  Macintosh HD               ��&eH+    d
iPhoto.app                                                       �w����        ����  	                Applications    ��^�      ��      d  $Macintosh HD:Applications:iPhoto.app   
 i P h o t o . a p p    M a c i n t o s h   H D  Applications/iPhoto.app   / ��  ��   m  l     �X�W�X  �W   �V l r��U Z r��T�S o  rs�R�R (0 openfolderinfinder openFolderInFinder O v� I z��Q�P
�Q .aevtodocnull  �    alis 4  z��O
�O 
cfol o  |�N�N (0 commentsfolderpath commentsFolderPath�P   m  vw f�T  �S  �U  �V       �M ! �L�K / 5"#$%&�J�I�H�G�F�M    �E�D�C�B�A�@�?�>�=�<�;�:�9�8�7�6
�E .aevtoappnull  �   � ****�D (0 commentsfoldername commentsFolderName�C 0 stripjpg stripJPG�B (0 openfolderinfinder openFolderInFinder�A &0 commentfilesuffix commentFileSuffix�@ *0 requiredalbumprefix requiredAlbumPrefix�? (0 commentsfolderpath commentsFolderPath�> 0 commenttext commentText�= "0 commentfilename commentFilename�< "0 photoexportpath photoExportPath�; 0 photofilename photoFilename�: 0 f  �9  �8  �7  �6  ! �5'�4�3()�2
�5 .aevtoappnull  �   � ****' k    �**  ++  ,,  %--  *..  0//  ;00  l11 �1�1  �4  �3  ( �0�/�0 0 thealbum theAlbum�/ 0 thephoto thePhoto) 5 �.�-�, /�+ 5�* f�)�(�'�&�%�$�#�"�!� ����2����������� � � �� �������
�	������. (0 commentsfoldername commentsFolderName�- 0 stripjpg stripJPG�, (0 openfolderinfinder openFolderInFinder�+ &0 commentfilesuffix commentFileSuffix�* *0 requiredalbumprefix requiredAlbumPrefix
�) afdrpdoc
�( .earsffdralis        afdr
�' 
cfol
�& kfrmname
�% .coredoexbool        obj 
�$ 
kocl
�# 
insh
�" 
prdt
�! 
pnam�  
� .corecrel****      � null
� 
ctxt� (0 commentsfolderpath commentsFolderPath
� 
ipal2  
� 
cobj
� .corecnte****       ****
� 
ipmr
� 
pcom
� 
utxt� 0 commenttext commentText
� 
filn� "0 commentfilename commentFilename
� 
ipth� "0 photoexportpath photoExportPath� 0 photofilename photoFilename���
� 
file
� 
perm
� .rdwropenshor       file� 0 f  
� 
set2
�
 .rdwrseofnull���     ****
�	 
refn
� 
as  � 
� .rdwrwritnull���     ****
� .rdwrclosnull���     ****
� .aevtodocnull  �    alis�2��E�OeE�OeE�O�E�O�E�O� C�j 
���0j  *����j 
a a �la  Y hO�j 
���0a &E` OPUOa *a -a [a ,\Z�>1[�a l kh   �a -[�a l kh �a ,a &E` O�a ,E`  O�a !,E` "O�a ,E` #O� <_  a $ )ja %_  %a &%OPY hO_  [a \[Zk\Za '2E`  OPY hO_  �%E`  O_ a ( G*a )_ _  %/a *el +E` ,O_ ,a -jl .O_ a /_ ,a 0a a 1 2O_ ,j 3Y hOP[OY�2OP[OY�OPUO� � *�_ /j 4UY h
�L boovtrue
�K boovtrue" S MMacintosh HD:Users:benoit:Pictures:iPhoto Library - My Comments Cache - Flat:   # �33 " L e s   g a r s   a u   d o d o !$ �44 ( I M G _ 1 6 6 0 . c o m m e n t . t x t% �55 � / U s e r s / b e n o i t / P i c t u r e s / i P h o t o   L i b r a r y   2 0 0 6 / 2 0 0 6 / 0 9 / 0 7 / I M G _ 1 6 6 0 . J P G& �66  I M G _ 1 6 6 0 . J P G�J @�I  �H  �G  �F   ascr  ��ޭ