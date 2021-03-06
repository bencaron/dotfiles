FasdUAS 1.101.10   ��   ��    k             l     �� ��    $  Export iPhoto Comments - Flat       	  l     �� 
��   
.( Creates a text file corresponding to each picture with a comment, containing just the comment. The filenames of the text files correspond to the filenames of the images. So avoid having more than one image with the same filename (taken by two different cameras with similar naming conventions, perhaps). This isn�t a problem for most people, but if it is for you, use the slightly more complex version of the script that duplicates the iPhoto folder hierarchy: <http://www.shearersoftware.com/personal/weblog/2004/01/18/iphoto-4-has-comments-no-more>.    	     l     �� ��   }w Note: this does not remove files in the comments folder when a comment disappears (due to deletion of either the comment or the image). To guard against this, you may want to delete the whole comment folder before rerunning this script. (Using a separate folder rather than storing comment files alongside the image makes this easier; you can flush the whole cache at once.)         l     �� ��    o i Written to work around the fact that iPhoto 4 no longer stores photo comments in the AlbumData.xml file.         l     �� ��    R L by Andrew Shearer, 2004-01-25 <mailto:ashearerw at shearersoftware dot com>         l     ������  ��        l     ������  ��        l     �� ��      config         l     ��  r         m          / )iPhoto Library - My Comments Cache - Flat     o      ���� (0 commentsfoldername commentsFolderName��     ! " ! l    # $ # r     % & % m    ��
�� boovtrue & o      ���� 0 stripjpg stripJPG $ % whether to strip .JPG extension    "  ' ( ' l    )�� ) r     * + * m    	��
�� boovtrue + o      ���� (0 openfolderinfinder openFolderInFinder��   (  , - , l    .�� . r     / 0 / m     1 1  .comment.txt    0 o      ���� &0 commentfilesuffix commentFileSuffix��   -  2 3 2 l    4�� 4 r     5 6 5 m     7 7 
 Web-    6 o      ���� *0 requiredalbumprefix requiredAlbumPrefix��   3  8 9 8 l     �� :��   :   end config    9  ; < ; l     ������  ��   <  = > = l   Z ?�� ? O    Z @ A @ k    Y B B  C D C l   �� E��   E 5 /return some folder of (path to pictures folder)    D  F G F Z   E H I���� H H    & J J l   % K�� K I   %�� L��
�� .coredoexbool        obj  L n    ! M N M 5    !�� O��
�� 
cfol O o    ���� (0 commentsfoldername commentsFolderName
�� kfrmname N l    P�� P I   �� Q��
�� .earsffdralis        afdr Q m    ��
�� afdrpdoc��  ��  ��  ��   I I  ) A���� R
�� .corecrel****      � null��   R �� S T
�� 
kocl S m   + ,��
�� 
cfol T �� U V
�� 
insh U l  - 2 W�� W I  - 2�� X��
�� .earsffdralis        afdr X m   - .��
�� afdrpdoc��  ��   V �� Y��
�� 
prdt Y K   5 ; Z Z �� [��
�� 
pnam [ o   8 9���� (0 commentsfoldername commentsFolderName��  ��  ��  ��   G  \ ] \ r   F W ^ _ ^ c   F S ` a ` n   F O b c b 5   K O�� d��
�� 
cfol d o   L M���� (0 commentsfoldername commentsFolderName
�� kfrmname c l  F K e�� e I  F K�� f��
�� .earsffdralis        afdr f m   F G��
�� afdrpdoc��  ��   a m   O R��
�� 
ctxt _ o      ���� (0 commentsfolderpath commentsFolderPath ]  g�� g l  X X������  ��  ��   A m     h h�null     ߀��  "
Finder.appn the AlbumData.xml file.cache at once.)t or the imagMACS   alis    r  Macintosh HD               ��&eH+    "
Finder.app                                                       7#���(        ����  	                CoreServices    ��^�      ���h      "      3Macintosh HD:System:Library:CoreServices:Finder.app    
 F i n d e r . a p p    M a c i n t o s h   H D  &System/Library/CoreServices/Finder.app  / ��  ��   >  i j i l     �� k��   k \ Vset commentsFolderPath to POSIX path of (path to pictures folder) & commentsFolderName    j  l m l l     ������  ��   m  n o n l  [^ p�� p O   [^ q r q k   a] s s  t u t l  a[ v w v X   a[ x�� y x k   �V z z  { | { l  �T } ~ } X   �T �� �  k   �O � �  � � � r   � � � � � c   � � � � � n   � � � � � 1   � ���
�� 
pcom � o   � ����� 0 thephoto thePhoto � m   � ���
�� 
utxt � o      ���� 0 commenttext commentText �  � � � r   � � � � � n   � � � � � 1   � ���
�� 
filn � o   � ����� 0 thephoto thePhoto � o      ���� "0 commentfilename commentFilename �  � � � Z   �  � ����� � o   � ����� 0 stripjpg stripJPG � k   � � � �  � � � l  � ��� ���   � %  strip .JPG suffix (optionally)    �  � � � Z   � � � ����� � H   � � � � D   � � � � � o   � ����� "0 commentfilename commentFilename � m   � � � � 
 .JPG    � k   � � � �  � � � R   � ��� ���
�� .ascrerr ****      � **** � b   � � � � � b   � � � � � m   � � � � + %Error: file does not end with .JPG: "    � o   � ����� "0 commentfilename commentFilename � m   � � � �  "   ��   �  ��� � l  � �������  ��  ��  ��  ��   �  � � � r   � � � � � n   � � � � � 7 � ��� � �
�� 
ctxt � m   � �����  � m   � ������� � o   � ����� "0 commentfilename commentFilename � o      ���� "0 commentfilename commentFilename �  ��� � l  � �������  ��  ��  ��  ��   �  � � � l �� ���   � < 6 add suffix to comment filename (.txt extension, etc.)    �  � � � r  
 � � � b   � � � o  ���� "0 commentfilename commentFilename � o  ���� &0 commentfilesuffix commentFileSuffix � o      ���� "0 commentfilename commentFilename �  � � � l ������  ��   �  � � � r  # � � � I �� � �
�� .rdwropenshor       file � 4  �� �
�� 
file � l  ��� � b   � � � o  ���� (0 commentsfolderpath commentsFolderPath � o  ���� "0 commentfilename commentFilename��   � �� ���
�� 
perm � m  ��
�� boovtrue��   � o      ���� 0 f   �  � � � l $/ � � � I $/�� � �
�� .rdwrseofnull���     **** � o  $'���� 0 f   � �� ���
�� 
set2 � m  *+����  ��   � , & truncate file, or old data can remain    �  � � � I 0E�� � �
�� .rdwrwritnull���     **** � o  03���� 0 commenttext commentText � �� � �
�� 
refn � o  69���� 0 f   � �� ���
�� 
as   � m  <?��
�� 
utxt��   �  � � � I FM�� ���
�� .rdwrclosnull���     **** � o  FI�� 0 f  ��   �  ��~ � l NN�}�|�}  �|  �~  �� 0 thephoto thePhoto � l  � � ��{ � 6  � � � � � n   � � � � � 2   � ��z
�z 
ipmr � o   � ��y�y 0 thealbum theAlbum � >  � � � � � 1   � ��x
�x 
pcom � m   � � � �      �{   ~   photos in album    |  ��w � l UU�v�u�v  �u  �w  �� 0 thealbum theAlbum y l  d v ��t � 6  d v � � � 2   d i�s
�s 
ipal � C   l u � � � 1   m q�r
�r 
pnam � o   r t�q�q *0 requiredalbumprefix requiredAlbumPrefix�t   w   albums    u  ��p � l \\�o�n�o  �n  �p   r m   [ ^ � ��null     ߀��  d
iPhoto.apperNamelbumData.xml fil�� �MQ�    �h$   �Ø�����iPho   alis    L  Macintosh HD               ��&eH+    d
iPhoto.app                                                       �w����        ����  	                Applications    ��^�      ��      d  $Macintosh HD:Applications:iPhoto.app   
 i P h o t o . a p p    M a c i n t o s h   H D  Applications/iPhoto.app   / ��  ��   o  � � � l     �m�l�m  �l   �  ��k � l _v ��j � Z _v � ��i�h � o  _`�g�g (0 openfolderinfinder openFolderInFinder � O cr � � � I gq�f ��e
�f .aevtodocnull  �    alis � 4  gm�d �
�d 
cfol � o  il�c�c (0 commentsfolderpath commentsFolderPath�e   � m  cd h�i  �h  �j  �k       �b � ��b   � �a
�a .aevtoappnull  �   � **** � �` ��_�^ � ��]
�` .aevtoappnull  �   � **** � k    v � �   � �  ! � �  ' � �  , � �  2    =  n  ��\�\  �_  �^   � �[�Z�[ 0 thealbum theAlbum�Z 0 thephoto thePhoto � 2  �Y�X�W 1�V 7�U h�T�S�R�Q�P�O�N�M�L�K�J�I�H ��G�F�E�D�C ��B�A�@�? � � ��>�=�<�;�:�9�8�7�6�5�4�3�2�Y (0 commentsfoldername commentsFolderName�X 0 stripjpg stripJPG�W (0 openfolderinfinder openFolderInFinder�V &0 commentfilesuffix commentFileSuffix�U *0 requiredalbumprefix requiredAlbumPrefix
�T afdrpdoc
�S .earsffdralis        afdr
�R 
cfol
�Q kfrmname
�P .coredoexbool        obj 
�O 
kocl
�N 
insh
�M 
prdt
�L 
pnam�K 
�J .corecrel****      � null
�I 
ctxt�H (0 commentsfolderpath commentsFolderPath
�G 
ipal  
�F 
cobj
�E .corecnte****       ****
�D 
ipmr
�C 
pcom
�B 
utxt�A 0 commenttext commentText
�@ 
filn�? "0 commentfilename commentFilename�>��
�= 
file
�< 
perm
�; .rdwropenshor       file�: 0 f  
�9 
set2
�8 .rdwrseofnull���     ****
�7 
refn
�6 
as  �5 
�4 .rdwrwritnull���     ****
�3 .rdwrclosnull���     ****
�2 .aevtodocnull  �    alis�]w�E�OeE�OeE�O�E�O�E�O� C�j 
���0j  *����j 
a a �la  Y hO�j 
���0a &E` OPUOa  � �*a -a [a ,\Z�>1[�a l kh   Ϡa -a [a ,\Za 91[�a l kh �a ,a &E` O�a  ,E` !O� <_ !a " )ja #_ !%a $%OPY hO_ ![a \[Zk\Za %2E` !OPY hO_ !�%E` !O*a &_ _ !%/a 'el (E` )O_ )a *jl +O_ a ,_ )a -a a . /O_ )j 0OP[OY�TOP[OY�(OPUO� � *�_ /j 1UY hascr  ��ޭ