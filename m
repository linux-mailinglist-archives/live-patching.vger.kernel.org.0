Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB9A1BE292
	for <lists+live-patching@lfdr.de>; Wed, 29 Apr 2020 17:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727789AbgD2PZZ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 29 Apr 2020 11:25:25 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:54543 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727841AbgD2PZY (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 29 Apr 2020 11:25:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588173923;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EBRv2/+FDr/lrTbtQJ9do2irFBLZgBPX8/+zXznQJVc=;
        b=SeL0+YWRcdwQYYhRK3VAF1VYeXPb4+9AXB9EGaN7I6j32VtvRbUoUEx2Ag9n/sYDRfP7aK
        Lqt5/QqD+RhO7IKa5ryBjMJMWZH1/3CIdm1JKZMLVqFdIP/mm4fIvTFPwJcKgfqtAx5Gqr
        dz11W0Ht4FBuD2A/l362RtAMkjJthLo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-484-nQ9Y17OhP_SCQKoP7uXdJw-1; Wed, 29 Apr 2020 11:25:20 -0400
X-MC-Unique: nQ9Y17OhP_SCQKoP7uXdJw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 60C468054AE;
        Wed, 29 Apr 2020 15:25:11 +0000 (UTC)
Received: from treble.redhat.com (ovpn-113-19.rdu2.redhat.com [10.10.113.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A00E763F65;
        Wed, 29 Apr 2020 15:25:10 +0000 (UTC)
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     live-patching@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>
Subject: [PATCH v4 08/11] livepatch: Remove module_disable_ro() usage
Date:   Wed, 29 Apr 2020 10:24:50 -0500
Message-Id: <100e5d6720353ee26acf0dd01511884d509f8cc5.1588173720.git.jpoimboe@redhat.com>
In-Reply-To: <cover.1588173720.git.jpoimboe@redhat.com>
References: <cover.1588173720.git.jpoimboe@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

With arch_klp_init_object_loaded() gone, and apply_relocate_add() now
using text_poke(), livepatch no longer needs to use module_disable_ro().

Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Joe Lawrence <joe.lawrence@redhat.com>
Acked-by: Miroslav Benes <mbenes@suse.cz>
---
 kernel/livepatch/core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index f9ebb54affab..6b8b3c067be0 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -777,7 +777,6 @@ static int klp_init_object_loaded(struct klp_patch *p=
atch,
 	if (klp_is_module(obj)) {
=20
 		mutex_lock(&text_mutex);
-		module_disable_ro(patch->mod);
=20
 		/*
 		 * Only write module-specific relocations here
@@ -787,7 +786,6 @@ static int klp_init_object_loaded(struct klp_patch *p=
atch,
 		 */
 		ret =3D klp_apply_object_relocs(patch, obj);
=20
-		module_enable_ro(patch->mod, true);
 		mutex_unlock(&text_mutex);
=20
 		if (ret)
--=20
2.21.1

