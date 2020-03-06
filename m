Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF58217B820
	for <lists+live-patching@lfdr.de>; Fri,  6 Mar 2020 09:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726070AbgCFILQ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 6 Mar 2020 03:11:16 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:38693 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726026AbgCFILP (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 6 Mar 2020 03:11:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583482274;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=e2g/yNBSp4obAHP9e+z6b2wXSeS6uMWDcMmOHaljK0I=;
        b=dDcDS/51/XrJv5qybUan4i2u5Inn9qIFEJwCG/9JDM6j9gCfSd98O+TQvtVkHPwwLZIQbN
        3MYTIFLkE8eZ93PFCNsHUxuYdqA4dIigGgaRzz8pTxtoKk3DI00oMLWrczNgRFoKH84ePA
        ft7D3wFkbLButw/bDFbpqmqieemSdzM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-488-CbscrROZOwyS3W2sk38UnQ-1; Fri, 06 Mar 2020 03:11:12 -0500
X-MC-Unique: CbscrROZOwyS3W2sk38UnQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CB238189F785;
        Fri,  6 Mar 2020 08:11:11 +0000 (UTC)
Received: from shodan.usersys.redhat.com (unknown [10.43.17.65])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 99C3410027B0;
        Fri,  6 Mar 2020 08:11:11 +0000 (UTC)
Received: by shodan.usersys.redhat.com (Postfix, from userid 1000)
        id 41C491C0117; Fri,  6 Mar 2020 09:11:10 +0100 (CET)
From:   Artem Savkov <asavkov@redhat.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        Artem Savkov <asavkov@redhat.com>
Subject: [PATCH] ftrace: return first found result in lookup_rec()
Date:   Fri,  6 Mar 2020 09:10:35 +0100
Message-Id: <20200306081035.21213-1-asavkov@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

It appears that ip ranges can overlap so. In that case lookup_rec()
returns whatever results it got last even if it found nothing in last
searched page.

This breaks an obscure livepatch late module patching usecase:
  - load livepatch
  - load the patched module
  - unload livepatch
  - try to load livepatch again

To fix this return from lookup_rec() as soon as it found the record
containing searched-for ip. This used to be this way prior lookup_rec()
introduction.

Fixes: 7e16f581a817 ("ftrace: Separate out functionality from ftrace_loca=
tion_range()")
Signed-off-by: Artem Savkov <asavkov@redhat.com>
---
 kernel/trace/ftrace.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 3f7ee102868a..b0f5ee1fd6e4 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1547,8 +1547,10 @@ static struct dyn_ftrace *lookup_rec(unsigned long=
 start, unsigned long end)
 		rec =3D bsearch(&key, pg->records, pg->index,
 			      sizeof(struct dyn_ftrace),
 			      ftrace_cmp_recs);
+		if (rec)
+			return rec;
 	}
-	return rec;
+	return NULL;
 }
=20
 /**
--=20
2.21.1

