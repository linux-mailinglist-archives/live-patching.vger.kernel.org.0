Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C6C31ADF1B
	for <lists+live-patching@lfdr.de>; Fri, 17 Apr 2020 16:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730872AbgDQOE7 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 17 Apr 2020 10:04:59 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55148 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730862AbgDQOE6 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 17 Apr 2020 10:04:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587132297;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lwqAf8hQ9NZ4TwR6KHxknyiHwy4+5aOuDvj+iSYZvz4=;
        b=Tip7V2Tax4SY2YO3FGcFmNg/P5sdAK09JluAH70HQza1EbwFP91o5TE8mV+M56vADvNwJj
        LncUq1ZrQ1weUib9fCYn7YNIukrQwG95L5/aMdySVt/xCXhkYuN99p1t1u3do8CWmAXdEU
        DoKmX3eAtqIKmqbqB1oFpCgZodRWeeg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-147-4QB27YtqOdOiJeXkRNPgYw-1; Fri, 17 Apr 2020 10:04:54 -0400
X-MC-Unique: 4QB27YtqOdOiJeXkRNPgYw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D42B5107B29B;
        Fri, 17 Apr 2020 14:04:52 +0000 (UTC)
Received: from treble.redhat.com (ovpn-116-146.rdu2.redhat.com [10.10.116.146])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3572F5C1C5;
        Fri, 17 Apr 2020 14:04:52 +0000 (UTC)
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     live-patching@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>
Subject: [PATCH v2 8/9] livepatch: Remove module_disable_ro() usage
Date:   Fri, 17 Apr 2020 09:04:33 -0500
Message-Id: <11723c83107129047d3b9e5d5a026b14dce6d391.1587131959.git.jpoimboe@redhat.com>
In-Reply-To: <cover.1587131959.git.jpoimboe@redhat.com>
References: <cover.1587131959.git.jpoimboe@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

With arch_klp_init_object_loaded() gone, and apply_relocate_add() now
using text_poke(), livepatch no longer needs to use module_disable_ro().

The text_mutex usage can also be removed -- its purpose was to protect
against module permission change races.

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
---
 kernel/livepatch/core.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index a090185e8689..3ff886b911ae 100644
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

