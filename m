Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3C421ED60F
	for <lists+live-patching@lfdr.de>; Wed,  3 Jun 2020 20:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726088AbgFCSVk (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 3 Jun 2020 14:21:40 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:28481 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726076AbgFCSVj (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 3 Jun 2020 14:21:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591208498;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=+c1cgHsK07BrW3OA4NvtHTy/+/91BrD1QDQgKn/57QU=;
        b=LNpXPPCEIvG+GVvRWvLWsjTofgNOQj8WC0Ty0GTcI3gyI7pEyu47YbxwkML6OQG+bLvARX
        Cu16loYEK6mkemjGHu20qCmo+STi9ie57j6eWNvyQ9OgSUB3NHap/ypqANlkDJljdAWj/M
        LAMCIuJQFFN/oNXuMrAx7559rC2OMYM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-214-z6ZVHDynO0SDP4ytoFxXvQ-1; Wed, 03 Jun 2020 14:21:34 -0400
X-MC-Unique: z6ZVHDynO0SDP4ytoFxXvQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 608F2107ACF2;
        Wed,  3 Jun 2020 18:21:33 +0000 (UTC)
Received: from dm.redhat.com (unknown [10.10.67.78])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 982BD5D9CD;
        Wed,  3 Jun 2020 18:21:29 +0000 (UTC)
From:   Yannick Cote <ycote@redhat.com>
To:     live-patching@vger.kernel.org
Cc:     linux-kselftest@vger.kernel.org, joe.lawrence@redhat.com,
        linux-kernel@vger.kernel.org, pmladek@suse.com, mbenes@suse.cz,
        kamalesh@linux.vnet.ibm.com
Subject: [PATCH v2 0/4] selftests/livepatch: rework of test-klp-{callbacks,shadow_vars}
Date:   Wed,  3 Jun 2020 14:20:54 -0400
Message-Id: <20200603182058.109470-1-ycote@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

v2:
 - drop completion variables and flush workqueue [pmladek]
 - comment typo/pr_info cleanup [kbabulal/mbenes]
 - cleanup goto ret assignations [pmladek]
 - allocate pndup[]'s, leave some svar allocations to
   shadow_get_or_alloc() [pmladek]
 - change allocation order for cleaner test dmesg output [pmladek]

The test-klp-callbacks change implements a synchronization replacement of
initial code which relied on solely on sleep delays. Remove the sleeps
and pass a block_transition flag from test script to module. Use
flush_workqueue() to serialize module output for test result
consideration.

The test-klp-shadow-vars changes first refactors the code to be more of
a readable example as well as continuing to verify the component code.
The patch is broken in two to display the renaming and restructuring in
part 1 and the addition and change of logic in part 2. The last change
frees memory before bailing in case of errors.

Patchset to be merged via the livepatching tree is against: livepatching/for-next

Joe Lawrence (1):
  selftests/livepatch: simplify test-klp-callbacks busy target tests

Yannick Cote (3):
  selftests/livepatch: rework test-klp-shadow-vars
  selftests/livepatch: more verification in test-klp-shadow-vars
  selftests/livepatch: fix mem leaks in test-klp-shadow-vars

 lib/livepatch/test_klp_callbacks_busy.c       |  37 ++-
 lib/livepatch/test_klp_shadow_vars.c          | 240 ++++++++++--------
 .../selftests/livepatch/test-callbacks.sh     |  29 +--
 .../selftests/livepatch/test-shadow-vars.sh   |  81 +++---
 4 files changed, 225 insertions(+), 162 deletions(-)

-- 
2.25.4

