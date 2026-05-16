Return-Path: <live-patching+bounces-2837-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qCgRHnQkCGoVbQMAu9opvQ
	(envelope-from <live-patching+bounces-2837-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Sat, 16 May 2026 10:01:56 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id A859155AB33
	for <lists+live-patching@lfdr.de>; Sat, 16 May 2026 10:01:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9643D3011A45
	for <lists+live-patching@lfdr.de>; Sat, 16 May 2026 08:01:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D21935AC13;
	Sat, 16 May 2026 08:01:53 +0000 (UTC)
X-Original-To: live-patching@vger.kernel.org
Received: from h3cspam02-ex.h3c.com (smtp.h3c.com [60.191.123.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3E8F5464D;
	Sat, 16 May 2026 08:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.191.123.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778918513; cv=none; b=shlMFdj98H/a4Xj+EzTHUEmbImUAbtqBJjlHCX12eFDq5sHrsvJaWbFGF9iNiQQNobjh20rCQEaYdJVGnKODQ4edpHitgGPeyUX7tFNcNNE5g3zE7oGE7K1kkZog1GkcgFXwGFkjgdzwLW+L4lJbp9R9Nu7jbIWN4LBM9veEe9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778918513; c=relaxed/simple;
	bh=YYBOT9SAw/kvvT59yW0yk0gldX2sepN5EQq2haYatJs=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=kr49uEbIar+xe8PYLCsa5Eu+wX7LUfE8twnV89qYD3jxwUhxG+Ppii9aw/1S+1n/jUzABVhgifhNaD+olpaHxLeh0qqGokuBKB8N+i27ezdEon8piOcPL5Zct++cWiW44gbztfN976pcfXGtgyHLiU/MnHt9KealOQCH263wxAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=h3c.com; spf=pass smtp.mailfrom=h3c.com; arc=none smtp.client-ip=60.191.123.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=h3c.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h3c.com
Received: from mail.maildlp.com ([172.25.15.154])
	by h3cspam02-ex.h3c.com with ESMTP id 64G80A55093149;
	Sat, 16 May 2026 16:00:10 +0800 (+08)
	(envelope-from lu.haoA@h3c.com)
Received: from DAG6EX08-BJD.srv.huawei-3com.com (unknown [10.153.34.10])
	by mail.maildlp.com (Postfix) with ESMTP id B0F0A20045B7;
	Sat, 16 May 2026 16:12:17 +0800 (CST)
Received: from localhost.localdomain (10.114.186.34) by
 DAG6EX08-BJD.srv.huawei-3com.com (10.153.34.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1258.27; Sat, 16 May 2026 16:00:10 +0800
From: luhao <lu.haoA@h3c.com>
To: <jpoimboe@kernel.org>, <jikos@kernel.org>, <mbenes@suse.cz>,
        <pmladek@suse.com>
CC: <joe.lawrence@redhat.com>, <live-patching@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <zhang.chunA@h3c.com>,
        <wang.shijie@h3c.com>, <lu.haoA@h3c.com>
Subject: [PATCH] livepatch: Improve the accuracy of symbol search
Date: Sat, 16 May 2026 16:08:33 +0800
Message-ID: <20260516080833.218948-1-lu.haoA@h3c.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: BJSMTP01-EX.srv.huawei-3com.com (10.63.20.132) To
 DAG6EX08-BJD.srv.huawei-3com.com (10.153.34.10)
X-DNSRBL: 
X-SPAM-SOURCE-CHECK: pass
X-MAIL:h3cspam02-ex.h3c.com 64G80A55093149
X-Rspamd-Queue-Id: A859155AB33
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.04 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DMARC_NA(0.00)[h3c.com];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2837-lists,live-patching=lfdr.de];
	RCPT_COUNT_SEVEN(0.00)[10];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[lu.haoA@h3c.com,live-patching@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	RCVD_COUNT_FIVE(0.00)[6];
	NEURAL_HAM(-0.00)[-0.998];
	TO_DN_NONE(0.00)[];
	R_DKIM_NA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Action: no action

module_kallsyms_on_each_symbol, when the input parameter modname is not
 empty, only searches for symbols within the current module. When
patching a kernel object (ko), if the patched function calls
functions from vmlinux or other ko modules, symbol lookup may fail.

When patching a ko, the current approach first searches for symbols
within the module itself. If not found, it uses
kallsyms_on_each_match_symbol to search in vmlinux. If still not
found, it calls module_kallsyms_on_each_symbol with modname set to
NULL to search across all ko modules. The reason for not searching
across all ko modules from the start is to avoid issues with
duplicate symbol names.

Reviewed-by: zhangchun <zhang.chunA@h3c.com>
Reviewed-by: wangshijie <wang.shijie@h3c.com>
Signed-off-by: luhao <lu.haoA@h3c.com>
---
 kernel/livepatch/core.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 28d15ba58a26..9c587cc4896b 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -167,9 +167,14 @@ static int klp_find_object_symbol(const char *objname,=
 const char *name,
                .pos =3D sympos,
        };

-       if (objname)
+       if (objname) {
                module_kallsyms_on_each_symbol(objname, klp_find_callback, =
&args);
-       else
+
+               if (args.addr =3D=3D 0)
+                       kallsyms_on_each_match_symbol(klp_match_callback, n=
ame, &args);
+               if (args.addr =3D=3D 0)
+                       module_kallsyms_on_each_symbol(NULL, klp_find_callb=
ack, &args);
+       } else
                kallsyms_on_each_match_symbol(klp_match_callback, name, &ar=
gs);

        /*
--
2.51.0

---------------------------------------------------------------------------=
----------------------------------------------------------
=B1=BE=D3=CA=BC=FE=BC=B0=C6=E4=B8=BD=BC=FE=BA=AC=D3=D0=D0=C2=BB=AA=C8=FD=BC=
=AF=CD=C5=B5=C4=B1=A3=C3=DC=D0=C5=CF=A2=A3=AC=BD=F6=CF=DE=D3=DA=B7=A2=CB=CD=
=B8=F8=C9=CF=C3=E6=B5=D8=D6=B7=D6=D0=C1=D0=B3=F6=B5=C4=B8=F6=C8=CB=BB=F2=C8=
=BA=D7=E9=A1=A3
=BD=FB=D6=B9=C8=CE=BA=CE=C6=E4=CB=FB=C8=CB=D2=D4=C8=CE=BA=CE=D0=CE=CA=BD=CA=
=B9=D3=C3=A3=A8=B0=FC=C0=A8=B5=AB=B2=BB=CF=DE=D3=DA=C8=AB=B2=BF=BB=F2=B2=BF=
=B7=D6=B5=D8=D0=B9=C2=B6=A1=A2=B8=B4=D6=C6=A1=A2=BB=F2=C9=A2=B7=A2=A3=A9=B1=
=BE=D3=CA=BC=FE=D6=D0=B5=C4=D0=C5=CF=A2=A1=A3
=C8=E7=B9=FB=C4=FA=B4=ED=CA=D5=C1=CB=B1=BE=D3=CA=BC=FE=A3=AC=C7=EB=C4=FA=C1=
=A2=BC=B4=B5=E7=BB=B0=BB=F2=D3=CA=BC=FE=CD=A8=D6=AA=B7=A2=BC=FE=C8=CB=B2=A2=
=C9=BE=B3=FD=B1=BE=D3=CA=BC=FE=A3=A1
This e-mail and its attachments contain confidential information from New H=
3C, which is intended only for the person or entity whose address is listed=
 above.
Any use of the information contained herein in any way (including, but not =
limited to, total or partial disclosure, reproduction, or dissemination) by=
 persons other than the intended recipient(s) is prohibited.
If you receive this e-mail in error, please notify the sender by phone or e=
mail immediately and delete it!

