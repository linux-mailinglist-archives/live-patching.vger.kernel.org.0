Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF1C817C4AB
	for <lists+live-patching@lfdr.de>; Fri,  6 Mar 2020 18:43:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726178AbgCFRn3 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 6 Mar 2020 12:43:29 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:34343 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725873AbgCFRn3 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 6 Mar 2020 12:43:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583516608;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hQDYGrSZez13kaLQWFtQ3x9F4gdNnjFBgu39A3ps7Ig=;
        b=b4pGnJNQrtjzwhCqRErII/mfsq4qz9k2p3BmhOnN9koFnXxPlAzSco4s9w0lTxG74iGFeH
        C2M5MASNQZqLYwXXn40hFqnMbY1spbQ+Dl0wxGCWPyPJO4a8zJ111id9jU8tqJw7i8DXqZ
        BFQtlISVvpQc9pNetBLHJt0UG4+mGCQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-171-YLIECvZuOtuVeYOipalFOg-1; Fri, 06 Mar 2020 12:43:26 -0500
X-MC-Unique: YLIECvZuOtuVeYOipalFOg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 28D841937FC2;
        Fri,  6 Mar 2020 17:43:25 +0000 (UTC)
Received: from shodan.usersys.redhat.com (unknown [10.43.17.65])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EB4B67386E;
        Fri,  6 Mar 2020 17:43:24 +0000 (UTC)
Received: by shodan.usersys.redhat.com (Postfix, from userid 1000)
        id 99E571C0183; Fri,  6 Mar 2020 18:43:23 +0100 (CET)
From:   Artem Savkov <asavkov@redhat.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        Artem Savkov <asavkov@redhat.com>
Subject: [PATCH v2] ftrace: return first found result in lookup_rec()
Date:   Fri,  6 Mar 2020 18:43:17 +0100
Message-Id: <20200306174317.21699-1-asavkov@redhat.com>
In-Reply-To: <20200306121246.5dac2573@gandalf.local.home>
References: <20200306121246.5dac2573@gandalf.local.home>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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

v2: break instead of two returns

Fixes: 7e16f581a817 ("ftrace: Separate out functionality from ftrace_loca=
tion_range()")
Signed-off-by: Artem Savkov <asavkov@redhat.com>
---
 kernel/trace/ftrace.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 3f7ee102868a..fd81c7de77a7 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1547,6 +1547,8 @@ static struct dyn_ftrace *lookup_rec(unsigned long =
start, unsigned long end)
 		rec =3D bsearch(&key, pg->records, pg->index,
 			      sizeof(struct dyn_ftrace),
 			      ftrace_cmp_recs);
+		if (rec)
+			break;
 	}
 	return rec;
 }
--=20
2.21.1

