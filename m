Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D53061A8503
	for <lists+live-patching@lfdr.de>; Tue, 14 Apr 2020 18:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391721AbgDNQcO (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 14 Apr 2020 12:32:14 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:21079 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2391617AbgDNQ3Q (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 14 Apr 2020 12:29:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586881747;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ansrsv2hxb0Ty4Mz0j8p11EC1rt+8+lNlWzTh4/A3Hw=;
        b=EDQ545hgCMtJITFhLzlQgrnDiCTwpb6zs68jT6jKdtJ+JzGTS6b86LRsIsv/A59oWOeYqr
        ozAKdUMwxtGViF3dH7jwHU9TmzEDktNZGR8RiuqPNF/9tdIEG6vi/VyZF2DQlavVo6XREo
        G7lv92z8iu/ezJYZ0imYyNh6s7jaGvc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-213-j6zz4NoGO5ebvhD9g9UlRg-1; Tue, 14 Apr 2020 12:29:05 -0400
X-MC-Unique: j6zz4NoGO5ebvhD9g9UlRg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6349918FF68E;
        Tue, 14 Apr 2020 16:29:02 +0000 (UTC)
Received: from treble.redhat.com (ovpn-116-146.rdu2.redhat.com [10.10.116.146])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A521D5DA66;
        Tue, 14 Apr 2020 16:29:01 +0000 (UTC)
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     live-patching@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>
Subject: [PATCH 6/7] livepatch: Remove module_disable_ro() usage
Date:   Tue, 14 Apr 2020 11:28:42 -0500
Message-Id: <9f0d8229bbe79d8c13c091ed70c41d49caf598f2.1586881704.git.jpoimboe@redhat.com>
In-Reply-To: <cover.1586881704.git.jpoimboe@redhat.com>
References: <cover.1586881704.git.jpoimboe@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

With arch_klp_init_object_loaded() gone, and apply_relocate_add() now
using text_poke(), livepatch no longer needs to use module_disable_ro().

The text_mutex usage can also be removed -- its purpose was to protect
against module permission change races.

Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
---
 kernel/livepatch/core.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 817676caddee..3a88639b3326 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -767,10 +767,6 @@ static int klp_init_object_loaded(struct klp_patch *=
patch,
 	struct klp_modinfo *info =3D patch->mod->klp_info;
=20
 	if (klp_is_module(obj)) {
-
-		mutex_lock(&text_mutex);
-		module_disable_ro(patch->mod);
-
 		/*
 		 * Only write module-specific relocations here
 		 * (.klp.rela.{module}.*).  vmlinux-specific relocations were
@@ -782,10 +778,6 @@ static int klp_init_object_loaded(struct klp_patch *=
patch,
 					    patch->mod->core_kallsyms.strtab,
 					    info->symndx, patch->mod,
 					    obj->name);
-
-		module_enable_ro(patch->mod, true);
-		mutex_unlock(&text_mutex);
-
 		if (ret)
 			return ret;
 	}
--=20
2.21.1

