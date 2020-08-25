Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACB082514FE
	for <lists+live-patching@lfdr.de>; Tue, 25 Aug 2020 11:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729205AbgHYJHn (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 25 Aug 2020 05:07:43 -0400
Received: from sonic303-1.consmr.mail.bf2.yahoo.com ([74.6.131.40]:33923 "EHLO
        sonic303-1.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729201AbgHYJHn (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 25 Aug 2020 05:07:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1598346461; bh=hkYSfrxTonACfliPSB6IYnWC0p+Veg0756S5roQpVX8=; h=Date:From:Reply-To:Subject:References:From:Subject; b=jtOwt1cGUPU8PikXMo3ltYAwNu+YsrBfsVmDM7mZqnlX0qcU9ZWaTu6rmT7PSmzSMKUT7DpLdxh5oHmuHD3a5z3saNoftmwhyW9+VimH1nu6TlpGvtUxKlMOT2ofqU9TYvq9VMxZiQmRpE2no/mixDoxEpJ8aoCFuvGvuw1J0CU75V5nA30hdcYmceESoegLXJzuuiJLyqGsa6jF/UuYt7QU60tNZPRGb4pIjsJ8UNqlqWhWqez+I6J18zMPSok6G16WaoJYBanKdzqvGIexYUqpoWIs6OI99NVYNH4tSlw0QnDgl3iO+sckiDX1Za3weqk2YuTKz9r+MWYYZHBajA==
X-YMail-OSG: a.csGUIVM1nRs5yjgFfqWmdHXm4zibTWJCs9FyC802tkhMRJ6tdPgn3eX2WkOHO
 .aVFaILlx9bOOXRgItdy3LM2LOhbwrJKcXSJzbHDNl.cHRwUkowU4TX23lvUOe98K38.XBy89.wx
 .2ZBzfHBfviL.87uMJX6FMGwsCYK5CuZlg7jtrcR4u7grUFOK.RuChOZ3z4OrEueuf8eNi1Lu_5U
 Ao.LSQB26QJxPRKoCm8d0a0WZt46MPVagDGOQwc0A_YYOTgW3iMu.xw.8QZJYeUaf7TjTrVXs7kj
 ggrqSb3FlKs1GNsLA7yZlNfBJ5W8OrZ8Hh5kGJKGCc1af2zsBmTsy_Qz5gKbieGMjuwgqBKu7YL5
 DjuB6yyx5WiUM4yxPnONcnQGKIHtYIxi.AxfnYXPZEvT.Nat4nnpWHdcKAx9cFZ4BLYTMfChX9JU
 VW9pg_7kXTLERcOQGhRrA8P1ySySrjtNB35HNNTnlESWltKdWMWUaaihB6D9ly_1A40tPSqwNUhV
 IxljG5V6i7s6FZzE3BEc5vYkmu4TjVWgQq9I.hsh_nvr8ZosXfIrlf5ggfPonM_XxQoMabo9QEzh
 RC9YBRBMmRCZWIBT5sAXLiYrTkhSAGeR92gf99eQ8MtehkXy4VvtRCrpgUUGIgPk9GS2Fs102zeI
 lJ4Fs8omc4bIASMZa1tii2mNoxyqqB12KVn0XydwnMczmuCclkbmlIYrZwx_rXae.fRs0j_SjxbZ
 yNdbMkI.rchXnmiBRXYKwuz8A22TyJPj3M0MdvojKIQkWYD9v_3umXQaroWIM79Ay0NTz8zWVcJy
 xFW0YCNSh57ex4Ia7E1ffTn669LLfq5TxfZ5zWxdgK1GSElAmmhNAnFbU3JQwVKmz53tbqnugRdP
 hGdlXRGMxsHBZf37xJtZvA0QgqvfNHoBBhJ7iqnId0aOGyMObXThgXPehBUFas2yO_Wt2EXKbd46
 Dz0qJQ1nnCFiGHHC._tmwNSehlT2OZ13IuvoahEzQlEXZFcUx7F2Muab3cU.GWCt3aS9iTvgY8ZU
 ru.CxkesIG4pZ18.bzGpFw9MZuqKM0E3VtCPbOrfZJjbwPlkEvVLeaQ8CgR4PtxhK3izwWGHZ_SM
 fImkepKPelOg8r9S9MZSycczyiXbcDhPWlQYpt3yLbcNbwoUWXWEUvv_pscs8AfKXwkBJHB01o1e
 aWeJg78K6vC8a1miwH9WNz.Efu_VuTCPybMjIfbvU7OAPEsglp6HOS_7JCrey0ToQdZyUXHufX0R
 DdtL.Iw1BCZVXdABnMb39lkzq8xpxgvEQFp9mk7irc8SYAnZ09aP0ngDXRSpnebMKzKFWekSJs6x
 EbDuzWwCegmDGXlwmKcpNpRXfgp28qewgjUF81Wtz.z1Xxb9fLRUHc.XaUCe1gxKnhnpQmHYij7i
 aIb2FTDafb.sL5ipg2libaHlWWPNx_OsiHdabNWo2M0HfEy8oG1c-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic303.consmr.mail.bf2.yahoo.com with HTTP; Tue, 25 Aug 2020 09:07:41 +0000
Date:   Tue, 25 Aug 2020 09:07:38 +0000 (UTC)
From:   Sgt Vivian Robert <sgtvivarob@gmail.com>
Reply-To: sgtvivarob@gmail.com
Message-ID: <560999273.5272175.1598346458271@mail.yahoo.com>
Subject:  kindly respond to my mail
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <560999273.5272175.1598346458271.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16455 YMailNodin Mozilla/5.0 (Windows NT 6.1; rv:79.0) Gecko/20100101 Firefox/79.0
To:     unlisted-recipients:; (no To-header on input)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



Good=C2=A0Day,=C2=A0I=C2=A0am=C2=A0glad=C2=A0to=C2=A0contact=C2=A0you=C2=A0=
through=C2=A0this=C2=A0medium=C2=A0I=E2=80=99m=C2=A0Sgt=C2=A0Vivian=C2=A0Ro=
bert=C2=A0am=C2=A0from=C2=A0united=C2=A0state,=C2=A028=C2=A0years=C2=A0old=
=C2=A0single=C2=A0I=C2=A0am=C2=A0the=C2=A0only=C2=A0surviving=C2=A0child=C2=
=A0of=C2=A0my=C2=A0late=C2=A0parents,=C2=A0I=C2=A0am=C2=A0America=C2=A0fema=
le=C2=A0soldier=C2=A0presently=C2=A0in=C2=A0Afghanistan=C2=A0for=C2=A0the=
=C2=A0training,=C2=A0advising=C2=A0the=C2=A0Afghan=C2=A0forces=C2=A0and=C2=
=A0also=C2=A0helping=C2=A0in=C2=A0stabilizing=C2=A0the=C2=A0country=C2=A0ag=
ainst=C2=A0security=C2=A0challenges,=C2=A0am=C2=A0Actually=C2=A0seeking=C2=
=A0your=C2=A0assistance=C2=A0to=C2=A0evacuate=C2=A0the=C2=A0sum=C2=A0of=C2=
=A0$3.5=C2=A0million,=C2=A0This=C2=A0money=C2=A0I=C2=A0got=C2=A0it=C2=A0as=
=C2=A0my=C2=A0reward=C2=A0in=C2=A0service=C2=A0by=C2=A0Afghanistan=C2=A0gov=
ernment=C2=A0to=C2=A0support=C2=A0me=C2=A0for=C2=A0my=C2=A0Good=C2=A0job=C2=
=A0in=C2=A0their=C2=A0land.=C2=A0Right=C2=A0now,=C2=A0I=C2=A0want=C2=A0you=
=C2=A0to=C2=A0stand=C2=A0as=C2=A0my=C2=A0beneficiary=C2=A0and=C2=A0receive=
=C2=A0the=C2=A0fund=C2=A0my=C2=A0certificate=C2=A0of=C2=A0deposit=C2=A0from=
=C2=A0the=C2=A0Bank=C2=A0where=C2=A0this=C2=A0fund=C2=A0deposited=C2=A0and=
=C2=A0my=C2=A0authorization=C2=A0letter=C2=A0is=C2=A0with=C2=A0me=C2=A0now.=
My=C2=A0contact=C2=A0with=C2=A0you=C2=A0is=C2=A0not=C2=A0by=C2=A0my=C2=A0po=
wer=C2=A0but=C2=A0it=C2=A0is=C2=A0divinely=C2=A0made=C2=A0for=C2=A0God's=C2=
=A0purpose=C2=A0to=C2=A0be=C2=A0fulfilled=C2=A0in=C2=A0our=C2=A0lives.=C2=
=A0I=C2=A0want=C2=A0you=C2=A0to=C2=A0be=C2=A0rest=C2=A0assured=C2=A0that=C2=
=A0this=C2=A0transaction=C2=A0is=C2=A0legitimate=C2=A0and=C2=A0a=C2=A0100%=
=C2=A0risk=C2=A0free=C2=A0involvement,=C2=A0all=C2=A0you=C2=A0have=C2=A0to=
=C2=A0do=C2=A0is=C2=A0to=C2=A0keep=C2=A0it=C2=A0secret=C2=A0and=C2=A0confid=
ential=C2=A0to=C2=A0yourself=C2=A0,=C2=A0this=C2=A0transaction=C2=A0will=C2=
=A0not=C2=A0take=C2=A0more=C2=A0than=C2=A07=C2=A0working=C2=A0banking=C2=A0=
days=C2=A0for=C2=A0the=C2=A0money=C2=A0to=C2=A0get=C2=A0into=C2=A0your=C2=
=A0account=C2=A0based=C2=A0on=C2=A0your=C2=A0sincerity=C2=A0and=C2=A0cooper=
ation.=C2=A0i=C2=A0want=C2=A0you=C2=A0to=C2=A0take=C2=A040%=C2=A0Percent=C2=
=A0of=C2=A0the=C2=A0total=C2=A0money=C2=A0for=C2=A0your=C2=A0personal=C2=A0=
use=C2=A0While=C2=A020%=C2=A0Percent=C2=A0of=C2=A0the=C2=A0money=C2=A0will=
=C2=A0go=C2=A0to=C2=A0charity,=C2=A0people=C2=A0in=C2=A0the=C2=A0street=C2=
=A0and=C2=A0helping=C2=A0the=C2=A0orphanage=C2=A0the=C2=A0remaining=C2=A040=
%=C2=A0percent=C2=A0of=C2=A0the=C2=A0total=C2=A0money=C2=A0.you=C2=A0will=
=C2=A0assist=C2=A0me=C2=A0to=C2=A0invest=C2=A0it=C2=A0in=C2=A0a=C2=A0good=
=C2=A0profitable=C2=A0Venture=C2=A0or=C2=A0you=C2=A0keep=C2=A0it=C2=A0for=
=C2=A0me=C2=A0until=C2=A0I=C2=A0arrive=C2=A0your=C2=A0country.=C2=A0If=C2=
=A0you=E2=80=99re=C2=A0willing=C2=A0to=C2=A0assist=C2=A0me=C2=A0contact=C2=
=A0me=C2=A0through=C2=A0my=C2=A0email=C2=A0address=C2=A0=E2=80=9Csgtvivarob=
@gmail.com.

Sgt=C2=A0Vivian=C2=A0Robert
