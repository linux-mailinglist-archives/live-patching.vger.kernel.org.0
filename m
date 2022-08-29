Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E150E5A46BD
	for <lists+live-patching@lfdr.de>; Mon, 29 Aug 2022 12:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbiH2KEL (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 29 Aug 2022 06:04:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiH2KEK (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 29 Aug 2022 06:04:10 -0400
Received: from mail-ua1-x92a.google.com (mail-ua1-x92a.google.com [IPv6:2607:f8b0:4864:20::92a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06B4A11803
        for <live-patching@vger.kernel.org>; Mon, 29 Aug 2022 03:04:08 -0700 (PDT)
Received: by mail-ua1-x92a.google.com with SMTP id s5so2917314uar.1
        for <live-patching@vger.kernel.org>; Mon, 29 Aug 2022 03:04:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc;
        bh=yz8tNLv5GDz9rHewhIeryS5KktdtpS5W9tcTVT6Lch0=;
        b=ZGdRrCUqLgRTF9p6WKR9p5Jk0Q6CXFQegrpGy9gbz33F7aczjH7SB6XVKERphRe4Z2
         WNuAvxDV0rWnp55ieTGZyEMImqf7fGobl/p3oDQM0JNEvZAOgI53pB8ExlJqD9kBsf8e
         z3qXHShd9nWe9F+gsSN/3Lw/KVWq6eiX715TDbQPjGy7Abo02Vpe1QjtF0Dj0v88W0S3
         RmJV9iV1NkVTKL6XY5icLEfB8TPHXq+X28hryp5BtmHIIT4Z/NdjElis6SPLV8BJhYto
         CufXCfR0N24k8JtUQ9qNcDAeFlxLvWfgi5dW1BaErzgswIwZpOJcLlQorPyQqLagMsrJ
         xG3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc;
        bh=yz8tNLv5GDz9rHewhIeryS5KktdtpS5W9tcTVT6Lch0=;
        b=kJVbSgcw9D9PSpCVKgln5iWo5MYaiuIuT4HL0CRtzpPOXy/CqjyuMaPyPBV3Zzf1r+
         Ia0HzLDY5ead9SSe+mN9gR4TH5o3+keBmF4fgeHCepgUnW2z574IAjNjSmG/iygBZOM6
         eSmXm0l8yrYHFOmOhKOIufrA47lZqZOd4Trdjdce6PS/YqnhJsOmKD5vpfsz8Uyc+/vM
         Qzgs+AkBA/7zxunYhQYIU2p9fz2YmG2rzMMuBQc+J7MERhzL84aiSfSyae3+AiQgz/IQ
         FakuDbZbe5Yq8beSArND5924n+mOm4PXaRDU0EhLE+yA6Innb894sNoY0Bct9cpvY2Xj
         67mg==
X-Gm-Message-State: ACgBeo2aTYZ3Fjae9s2O6ql9+dfNthpvPnWng1/2qm6I+A/iwqHgkW92
        piVE8Sz8PD8cbMg7leNEQnQtBcObEtw0Aqz9zOE=
X-Google-Smtp-Source: AA6agR46NGQv5D3RNN+HRNCtbMugso8jwVn1dvy8zFgCFD948aIw45i8Pz0+xe8bDKcNJV22BNb87Zuju8csEgbewAE=
X-Received: by 2002:ab0:2713:0:b0:391:50f7:88b5 with SMTP id
 s19-20020ab02713000000b0039150f788b5mr3131135uao.109.1661767447112; Mon, 29
 Aug 2022 03:04:07 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:612c:2813:b0:2ee:ab97:ec67 with HTTP; Mon, 29 Aug 2022
 03:04:06 -0700 (PDT)
Reply-To: mrtonyelumelu98@gmail.com
From:   "Mrs. Cristalina Georgieva" <ayshaayshaayshaaysha889765@gmail.com>
Date:   Mon, 29 Aug 2022 11:04:06 +0100
Message-ID: <CAAV5x9Os4DEd1ScUFRWYzVxyEn9h5vs97RpF=MddupxCfh1fQA@mail.gmail.com>
Subject: hi
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: Yes, score=7.5 required=5.0 tests=BAYES_95,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:92a listed in]
        [list.dnswl.org]
        *  3.0 BAYES_95 BODY: Bayes spam probability is 95 to 99%
        *      [score: 0.9897]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [ayshaayshaayshaaysha889765[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [ayshaayshaayshaaysha889765[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [mrtonyelumelu98[at]gmail.com]
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.2 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

5Zu96Zqb6YCa6LKo5Z+66YeRIChJTUYpDQrlm73pmpvlgrXli5nnrqHnkIboqrINCu+8gzE5MDDj
gIFBVi5EVeekvumVtw0KDQpJLk0uRi4g44OH44Kj44Os44Kv44K/44O844Gu5YWs5byP6Zu75a2Q
44Oh44O844OrIOOCouODieODrOOCueOBuOOCiOOBhuOBk+OBneOAguOCr+ODquOCueOCv+ODquOD
vOODiuODu+OCsuOCquODq+OCruOCqOODrw0KDQoNCuimquaEm+OBquOCi+WPl+ebiuiAhe+8gQ0K
DQrmlrDjgZ/jgavku7vlkb3jgZXjgozjgZ/osqHli5nplbflrpjjgajlm73pgKPpgJrosqjlvZPl
sYDjga7ntbHmsrvmqZ/plqLjga/jgIHlm73pgKPmlL/lupzjgavplbfjgYTplpPlgrXli5njgpLo
sqDjgaPjgabjgYTjgZ/mnKroq4vmsYLjga7os4fph5HjgpLoqr/mn7vjgZnjgovjgZPjgajjgpLo
qLHlj6/jgZfjgZ/jgZ/jgoHjgIHmiYDmnInogIXjga/oqZDmrLrjgaflkYrnmbrjgZXjgozjgb7j
gZfjgZ8u5Zu96YCj44Gu5ZCN5YmN44KS5L2/55So44GX44Gf6KmQ5qy65bir44CC6Kq/5p+75Lit
44Gu44K344K544OG44Og44Gu6Zu75a2Q44Oh44O844OrDQrjgqLjg4njg6zjgrnjga7jg4fjg7zj
gr8g44K544OI44Os44O844K46KiY6Yyy44Gr44KI44KL44Go44CB44GC44Gq44Gf44Gu5pSv5omV
44GE44Gv44CB5qyh44Gu44Kr44OG44K044Oq44GuIDE1MCDkurrjga7lj5fnm4rogIXjga7jg6rj
grnjg4jjgavlkKvjgb7jgozjgabjgYTjgb7jgZnjgILlpZHntITos4fph5HjgIINCg0K44GC44Gq
44Gf44Gu6LOH6YeR44KS44Gg44G+44GX5Y+W44KL44Gf44KB44Gr5rGa6IG344KS54qv44GX44Gf
6IWQ5pWX44GX44Gf6YqA6KGM6IG35ZOh44Gv44CB44GC44Gq44Gf44Gu5pSv5omV44GE44KS5LiN
5b2T44Gr6YGF44KJ44Gb44CB44GC44Gq44Gf44Gu5YG044Gr5aSa44GP44Gu6LK755So44GM44GL
44GL44KK44CB44GC44Gq44Gf44Gu5pSv5omV44GE44Gu5Y+X44GR5YWl44KM44GM5LiN5b2T44Gr
6YGF44KM44G+44GX44GfLuWbvemAo+OBqOWbvemam+mAmuiyqOWfuumHkQ0KKElNRikg44Gv44CB
5YyX57Gz44CB5Y2X57Gz44CB57Gz5Zu944CB44Oo44O844Ot44OD44OR44CB44Ki44K444Ki44CB
44GK44KI44Gz5LiW55WM5Lit44GuIEFUTSBWaXNhIOOCq+ODvOODieOCkuS9v+eUqOOBl+OBpiAx
NTANCuS6uuOBruWPl+ebiuiAheOBq+OBmeOBueOBpuOBruijnOWEn+OCkuaUr+aJleOBhuOBk+OB
qOOCkumBuOaKnuOBl+OBvuOBl+OBn+OAguOBk+OBruOCsOODreODvOODkOODq+OBquaUr+aJleOB
hOaKgOihk+OBjOWIqeeUqOWPr+iDveOBp+OBguOCi+OBn+OCgeOBp+OBmeOAgua2iOiyu+iAheOA
geS8gealreOAgemHkeiejeapn+mWouOBq+OAguaUv+W6nOOBjOePvumHkeOChOWwj+WIh+aJi+OB
ruS7o+OCj+OCiuOBq+ODh+OCuOOCv+ODq+mAmuiyqOOCkuS9v+eUqOOBp+OBjeOCi+OCiOOBhuOB
q+OBl+OBvuOBmeOAgg0KDQpBVE0gVmlzYeOCq+ODvOODieOCkuS9v+eUqOOBl+OBpuaUr+aJleOB
hOOCkuihjOOBhuOCiOOBhuOBq+aJi+mFjeOBl+OBvuOBl+OBn+OAguOCq+ODvOODieOBr+eZuuih
jOOBleOCjOOAgeWIqeeUqOWPr+iDveOBquWuhemFjeOCteODvOODk+OCueOCkuS7i+OBl+OBpueb
tOaOpeS9j+aJgOOBq+mAgeOCieOCjOOBvuOBmeOAguOBlOmAo+e1oeW+jOOAgTEsNTAwLDAwMC4w
MA0K57Gz44OJ44Or44Gu6YeR6aGN44GMIEFUTSBWaXNhIOOCq+ODvOODieOBq+i7oumAgeOBleOC
jOOBvuOBmeOAguOBk+OCjOOBq+OCiOOCiuOAgeOBiuS9j+OBvuOBhOOBruWbveOBriBBVE0g44GL
44KJIDEg5pel44GC44Gf44KK5bCR44Gq44GP44Go44KCIDEwLDAwMA0K57Gz44OJ44Or44KS5byV
44GN5Ye644GZ44GT44Go44Gn44CB44GK6YeR44KS5byV44GN5Ye644GZ44GT44Go44GM44Gn44GN
44G+44GZ44CC44GU6KaB5pyb44Gr5b+c44GY44Gm44CBMSDml6XjgYLjgZ/jgoogMjAsMDAwLjAw
DQrjg4njg6vjgb7jgafkuIrpmZDjgpLlvJXjgY3kuIrjgZLjgovjgZPjgajjgYzjgafjgY3jgb7j
gZnjgILjgZPjgozjgavplqLjgZfjgabjgIHlm73pmpvmlK/miZXjgYrjgojjgbPpgIHph5HlsYDj
gavpgKPntaHjgZfjgIHopoHmsYLjgZXjgozjgZ/mg4XloLHjgpLmrKHjga7mlrnms5Xjgafmj5Dk
vpvjgZnjgovlv4XopoHjgYzjgYLjgorjgb7jgZnjgIINCg0KMS7jgYLjgarjgZ/jga7jg5Xjg6vj
g43jg7zjg6AuLi4uLi4uLi4NCjIu44GC44Gq44Gf44Gu5a6M5YWo44Gq5L2P5omALi4uLi4uLi4N
CjMuIOWbveexjSAuLi4uLi4uLi4uLi4uLi4uLg0KNC7nlJ/lubTmnIjml6Xjg7vmgKfliKXigKbi
gKbigKbigKYNCjUu5bCC6ZaA5oCnLi4uLi4uLi4NCjYuIOmbu+ipseeVquWPtyAuLi4uLi4uLi4u
DQo3LiDlvqHnpL7jga7jg6Hjg7zjg6vjgqLjg4njg6zjgrnigKbigKYNCjgu5YCL5Lq644Gu44Oh
44O844Or44Ki44OJ44Os44K54oCm4oCmDQoNCg0K44GT44Gu44Kz44O844OJICjjg6rjg7Pjgq86
IENMSUVOVC05NjYvMTYpIOOCkuitmOWIpeOBmeOCi+OBq+OBr+OAgembu+WtkOODoeODvOODq+OB
ruS7tuWQjeOBqOOBl+OBpuS9v+eUqOOBl+OAgeS4iuiomOOBruaDheWgseOCkuasoeOBruW+k+al
reWToeOBq+aPkOS+m+OBl+OBpiBBVE0NClZpc2Eg44Kr44O844OJ44Gu55m66KGM44Go6YWN6YCB
44KS5L6d6aC844GX44Gm44GP44Gg44GV44GE44CCDQoNCumKgOihjOaLheW9k+iAheOBjOOBk+OB
ruaUr+aJleOBhOOCkui/vei3oeOBl+OAgeODoeODg+OCu+ODvOOCuOOCkuS6pOaPm+OBl+OBpuOA
geizh+mHkeOBruOBleOCieOBquOCi+mBheW7tuOChOiqpOOBo+OBn+aWueWQkeS7mOOBkeOCkumY
suOBkOOBk+OBqOOBjOOBp+OBjeOCi+OCiOOBhuOBq+OAgeaWsOOBl+OBhOeVquWPt+OBp+WAi+S6
uuOBrumbu+WtkOODoeODvOODqw0K44Ki44OJ44Os44K544KS6ZaL44GP44GT44Go44KS44GK5Yun
44KB44GX44G+44GZ44CC5Lul5LiL44Gu6YCj57Wh5YWI5oOF5aCx44KS5L2/55So44GX44Gm44CB
44Om44OK44Kk44OG44OD44OJIOODkOODs+OCryDjgqrjg5Yg44Ki44OV44Oq44Kr44Gu44Ko44O8
44K444Kn44Oz44OI44Gr5LuK44GZ44GQ44GU6YCj57Wh44GP44Gg44GV44GE44CCDQoNCumAo+e1
oeeqk+WPo++8muODiOODi+ODvOODu+OCqOODq+ODoeODq+awjw0K6KOc5YSf6YeR6YCB6YeR6YOo
IFVuaXRlZCBCYW5rIG9mIEFmcmljYSDpgKPntaHlhYjjg6Hjg7zjg6vjgqLjg4njg6zjgrk6ICwo
bXJ0b255ZWx1bWVsdTk4QGdtYWlsLmNvbSkNCg0K44GT44KM5Lul5LiK44Gu6YGF44KM44KS6YG/
44GR44KL44Gf44KB44Gr44CB44GT44Gu44Oh44O844Or44G444Gu6L+F6YCf44Gq5a++5b+c44GM
5b+F6KaB44Gn44GZ44CCDQoNCuaVrOWFtw0K44Kv44Oq44K544K/44Oq44O844OK44O744Ky44Kq
44Or44Ku44Ko44OQ5aSr5Lq6DQo=
