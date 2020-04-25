Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF0C81B85F3
	for <lists+live-patching@lfdr.de>; Sat, 25 Apr 2020 13:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726116AbgDYLIo (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sat, 25 Apr 2020 07:08:44 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:47911 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726050AbgDYLIo (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sat, 25 Apr 2020 07:08:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587812922;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TmXsj2wLOusjeYUdzrX/n2pPGal/ML+yFSxtbXAnG/Y=;
        b=Dx6aYQIvoBygsCSM/yBVqvip5SWNfZ5lY3w4xyyE9Br7YVgOD9zHKbj3/tXYYZgq9mgv28
        kFpIEwTE85kpsZmzcvsHcE6B5aIZ10yYmzulbFVh+N89xPnJdSqdRy2IbHgkpUjEU+W3VX
        a76R0zxAEeo90Tz6lz621IFSz/5Q3Rg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-25-KNOQLXCCMCmuFcIGfR50Yg-1; Sat, 25 Apr 2020 07:08:38 -0400
X-MC-Unique: KNOQLXCCMCmuFcIGfR50Yg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8FA1C1800D42;
        Sat, 25 Apr 2020 11:08:37 +0000 (UTC)
Received: from treble.redhat.com (ovpn-114-29.rdu2.redhat.com [10.10.114.29])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C8B23605D8;
        Sat, 25 Apr 2020 11:08:36 +0000 (UTC)
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     live-patching@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>
Subject: [PATCH v3 01/10] livepatch: Disallow vmlinux.ko
Date:   Sat, 25 Apr 2020 06:07:21 -0500
Message-Id: <89ad8839664154577ea83fce7b758cb9bb6a7f22.1587812518.git.jpoimboe@redhat.com>
In-Reply-To: <cover.1587812518.git.jpoimboe@redhat.com>
References: <cover.1587812518.git.jpoimboe@redhat.com>
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

