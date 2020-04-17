Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2441ADEF2
	for <lists+live-patching@lfdr.de>; Fri, 17 Apr 2020 16:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730765AbgDQOEu (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 17 Apr 2020 10:04:50 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:42176 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730744AbgDQOEu (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 17 Apr 2020 10:04:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587132289;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o8foZaTA908TKiqlCeHVCOn2XVeLTmA8LWaRlobZZ4U=;
        b=Z9BjD9UJ2fi+kr27dht6blCvnJG921ImE0IManixaMa8RUczuwYy4/H4jCWPdu+dQXlJlD
        GePxanydLnQqzbiKylsj/CSesF92gxHBgJQcqkXRhasZCrr4iR7RvJC30ZB+wZsP7CmYl7
        vTYhtdpGLhP2GIuCwbM6+xX6fP3iJLU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-162-Q9v-mqkWMqK-jFQWshYwvg-1; Fri, 17 Apr 2020 10:04:47 -0400
X-MC-Unique: Q9v-mqkWMqK-jFQWshYwvg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EF10B107ACC9;
        Fri, 17 Apr 2020 14:04:45 +0000 (UTC)
Received: from treble.redhat.com (ovpn-116-146.rdu2.redhat.com [10.10.116.146])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2039E5C1C5;
        Fri, 17 Apr 2020 14:04:45 +0000 (UTC)
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     live-patching@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>, Miroslav Benes <mbenes@suse.cz>
Subject: [PATCH v2 1/9] livepatch: Disallow vmlinux.ko
Date:   Fri, 17 Apr 2020 09:04:26 -0500
Message-Id: <68b2d27ce7991873ae3932e0f8f3f05c44dbc4f8.1587131959.git.jpoimboe@redhat.com>
In-Reply-To: <cover.1587131959.git.jpoimboe@redhat.com>
References: <cover.1587131959.git.jpoimboe@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

This is purely a theoretical issue, but if there were a module named
vmlinux.ko, the livepatch relocation code wouldn't be able to
distinguish between vmlinux-specific and vmlinux.o-specific KLP
relocations.

If CONFIG_LIVEPATCH is enabled, don't allow a module named vmlinux.ko.

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Miroslav Benes <mbenes@suse.cz>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
---
 kernel/livepatch/core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index c3512e7e0801..40cfac8156fd 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -1139,6 +1139,11 @@ int klp_module_coming(struct module *mod)
 	if (WARN_ON(mod->state !=3D MODULE_STATE_COMING))
 		return -EINVAL;
=20
+	if (!strcmp(mod->name, "vmlinux")) {
+		pr_err("vmlinux.ko: invalid module name");
+		return -EINVAL;
+	}
+
 	mutex_lock(&klp_mutex);
 	/*
 	 * Each module has to know that klp_module_coming()
--=20
2.21.1

