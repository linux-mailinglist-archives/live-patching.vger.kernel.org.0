Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D023228516
	for <lists+live-patching@lfdr.de>; Tue, 21 Jul 2020 18:14:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbgGUQOV (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 21 Jul 2020 12:14:21 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:52798 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728937AbgGUQOV (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 21 Jul 2020 12:14:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595348060;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fttba9JGvdKbIgcVzwQauTkDjKGnPsdP2CmXjF+odHQ=;
        b=WmqJqM5bLrHrSOHHbJk0K4nv4/cmkMDUVqPQbD5UIj+H5msPa3qTrqHHr6cpgbv4Ksi4+I
        4CUwF8JjqbbNG+szFbCao/aJDEiQmEE8NUS3NxQ0RZOBakehYUrskMoqnrGDifsCHZ3isZ
        FU/1qC8vUA4VLiYjLocMcnWzRWWr/1Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-153-UVCBfHMUPyqGz_SuqA1LmQ-1; Tue, 21 Jul 2020 12:14:18 -0400
X-MC-Unique: UVCBfHMUPyqGz_SuqA1LmQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3A2121DF0;
        Tue, 21 Jul 2020 16:14:17 +0000 (UTC)
Received: from jlaw-desktop.redhat.com (ovpn-114-255.rdu2.redhat.com [10.10.114.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DC4B28730C;
        Tue, 21 Jul 2020 16:14:16 +0000 (UTC)
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] samples/livepatch: Add README.rst disclaimer
Date:   Tue, 21 Jul 2020 12:14:07 -0400
Message-Id: <20200721161407.26806-3-joe.lawrence@redhat.com>
In-Reply-To: <20200721161407.26806-1-joe.lawrence@redhat.com>
References: <20200721161407.26806-1-joe.lawrence@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

The livepatch samples aren't very careful with respect to compiler
IPA-optimization of target kernel functions.

Add a quick disclaimer and pointer to the compiler-considerations.rst
file to warn readers.

Suggested-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
---
 samples/livepatch/README.rst | 15 +++++++++++++++
 1 file changed, 15 insertions(+)
 create mode 100644 samples/livepatch/README.rst

diff --git a/samples/livepatch/README.rst b/samples/livepatch/README.rst
new file mode 100644
index 000000000000..2f8ef945f2ac
--- /dev/null
+++ b/samples/livepatch/README.rst
@@ -0,0 +1,15 @@
+.. SPDX-License-Identifier: GPL-2.0+
+
+==========
+Disclaimer
+==========
+
+The livepatch sample programs were written with idealized compiler
+output in mind. That is to say that they do not consider ways in which
+optimization may transform target kernel functions.
+
+The samples present only a simple API demonstration and should not be
+considered completely safe.
+
+See the Documentation/livepatching/compiler-considerations.rst file for
+more details on compiler optimizations and how they affect livepatching.
-- 
2.21.3

