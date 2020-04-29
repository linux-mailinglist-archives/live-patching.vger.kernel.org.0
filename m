Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBBE41BE2A6
	for <lists+live-patching@lfdr.de>; Wed, 29 Apr 2020 17:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbgD2PZs (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 29 Apr 2020 11:25:48 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:53337 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727811AbgD2PZT (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 29 Apr 2020 11:25:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588173918;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=55lPP4/9P2Q2fFkp/oMOVjw5upNDuXiv/W3GLreRWds=;
        b=CIGx7IxTz1RWu9ycj7Y5lYXsfXUGlTlsQpjO46j6Qh+Z57OvmC8f0Y8Lusd4O1DOHguMTA
        x6NHITp4kHYpAfaoUG9+0ILiYsGy8UhGO6ZHQPao+1wWy7TmUTQ4GeEnLXFGUgu4/ie4a/
        wI1TQgLIvgerLoNmzVxOcyw6Yo0aPT8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-363-JmW7EMqpPkyIt8ZCOgbTkw-1; Wed, 29 Apr 2020 11:25:12 -0400
X-MC-Unique: JmW7EMqpPkyIt8ZCOgbTkw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 713438B904E;
        Wed, 29 Apr 2020 15:25:02 +0000 (UTC)
Received: from treble.redhat.com (ovpn-113-19.rdu2.redhat.com [10.10.113.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9B439605CB;
        Wed, 29 Apr 2020 15:25:01 +0000 (UTC)
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     live-patching@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>
Subject: [PATCH v4 01/11] livepatch: Disallow vmlinux.ko
Date:   Wed, 29 Apr 2020 10:24:43 -0500
Message-Id: <3c23f9861a49662b7b3ee83b3bc17ebf9824e242.1588173720.git.jpoimboe@redhat.com>
In-Reply-To: <cover.1588173720.git.jpoimboe@redhat.com>
References: <cover.1588173720.git.jpoimboe@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Acked-by: Miroslav Benes <mbenes@suse.cz>
Acked-by: Joe Lawrence <joe.lawrence@redhat.com>
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

