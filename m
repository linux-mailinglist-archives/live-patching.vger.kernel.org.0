Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23292228515
	for <lists+live-patching@lfdr.de>; Tue, 21 Jul 2020 18:14:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730192AbgGUQOV (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 21 Jul 2020 12:14:21 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:49654 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726890AbgGUQOV (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 21 Jul 2020 12:14:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595348059;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=nU4GN8DzMVkB2B4BGU+FEKLwNEwIFvzsJZa/gMO7RWg=;
        b=BBE+e/SnE5P0z2sUKspvAVz9JOWx/TjVv9XhoKPJlaywi8xAwO8dwJ9ss9Oiy1ay2pJmDi
        /S3VqRloXdDvjnlndgK/llcV9e20pS6k/Ri6ykyatvsDnCT42jjyYoWcQJlY78tLn3N0oO
        X6EXjLFZO4b2oLcA7qq+zX4dhxwO7gY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-223-xGPIJL10Pvahp9if4m2pyA-1; Tue, 21 Jul 2020 12:14:17 -0400
X-MC-Unique: xGPIJL10Pvahp9if4m2pyA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2EFBD800469;
        Tue, 21 Jul 2020 16:14:16 +0000 (UTC)
Received: from jlaw-desktop.redhat.com (ovpn-114-255.rdu2.redhat.com [10.10.114.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D18958730C;
        Tue, 21 Jul 2020 16:14:15 +0000 (UTC)
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] livepatch: Add compiler optimization disclaimer/docs
Date:   Tue, 21 Jul 2020 12:14:05 -0400
Message-Id: <20200721161407.26806-1-joe.lawrence@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

In light of [PATCH] Revert "kbuild: use -flive-patching when
CONFIG_LIVEPATCH is enabled" [1], we should add some loud disclaimers
and explanation of the impact compiler optimizations have on
livepatching.

The first commit provides detailed explanations and examples.  The list
was taken mostly from Miroslav's LPC talk a few years back.  This is a
bit rough, so corrections and additional suggestions welcome.  Expanding
upon the source-based patching approach would be helpful, too.

The second commit adds a small README.rst file in the livepatch samples
directory pointing the reader to the doc introduced in the first commit.

I didn't touch the livepatch kselftests yet as I'm still unsure about
how to best account for IPA here.  We could add the same README.rst
disclaimer here, too, but perhaps we have a chance to do something more.
Possibilities range from checking for renamed functions as part of their
build, or the selftest scripts, or even adding something to the kernel
API.  I think we'll have a better idea after reviewing the compiler
considerations doc.

[1] https://lore.kernel.org/lkml/696262e997359666afa053fe7d1a9fb2bb373964.1595010490.git.jpoimboe@redhat.com/

Joe Lawrence (2):
  docs/livepatch: Add new compiler considerations doc
  samples/livepatch: Add README.rst disclaimer

 .../livepatch/compiler-considerations.rst     | 220 ++++++++++++++++++
 Documentation/livepatch/index.rst             |   1 +
 Documentation/livepatch/livepatch.rst         |   7 +
 samples/livepatch/README.rst                  |  15 ++
 4 files changed, 243 insertions(+)
 create mode 100644 Documentation/livepatch/compiler-considerations.rst
 create mode 100644 samples/livepatch/README.rst

-- 
2.21.3

