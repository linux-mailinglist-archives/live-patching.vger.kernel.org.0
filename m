Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87BC01B8605
	for <lists+live-patching@lfdr.de>; Sat, 25 Apr 2020 13:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726284AbgDYLI6 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sat, 25 Apr 2020 07:08:58 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:59817 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726262AbgDYLI5 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sat, 25 Apr 2020 07:08:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587812936;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LKEepzAVCkQKxwp4tsPAZXxKU22P0OBrYEGsohWOvBY=;
        b=Y+ivHLgIAJJJeGmb519+mRHc49TtAyT5RoaI6x4+GOcpeNZXv3INTswzQ0Y4mD0PPWgDeE
        hCHrr6yT1nKFfKs9+k4vr26VC8QfUgcKjZqCaco0AyvuKTb5cGQhWSKR2Nb8xOSqJyOqKF
        UBXXYTfVusunwA4XGy8Vy9oRmX2gSdw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-364-9KPGV2IPNTKj0wHAP8qlvA-1; Sat, 25 Apr 2020 07:08:52 -0400
X-MC-Unique: 9KPGV2IPNTKj0wHAP8qlvA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 680C9800C78;
        Sat, 25 Apr 2020 11:08:51 +0000 (UTC)
Received: from treble.redhat.com (ovpn-114-29.rdu2.redhat.com [10.10.114.29])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8ED605C1D4;
        Sat, 25 Apr 2020 11:08:50 +0000 (UTC)
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     live-patching@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>
Subject: [PATCH v3 08/10] livepatch: Remove module_disable_ro() usage
Date:   Sat, 25 Apr 2020 06:07:28 -0500
Message-Id: <36eaeb7551e06e90dbb07e1bdaad8b0f4ff890da.1587812518.git.jpoimboe@redhat.com>
In-Reply-To: <cover.1587812518.git.jpoimboe@redhat.com>
References: <cover.1587812518.git.jpoimboe@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

With arch_klp_init_object_loaded() gone, and apply_relocate_add() now
using text_poke(), livepatch no longer needs to use module_disable_ro().

Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
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

