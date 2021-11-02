Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E09944310B
	for <lists+live-patching@lfdr.de>; Tue,  2 Nov 2021 15:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234299AbhKBPCZ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 2 Nov 2021 11:02:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:60839 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233675AbhKBPCZ (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 2 Nov 2021 11:02:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635865190;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=hVwoi1r2UgY2O+GlIt2GtWP2wjjCvE3wPDD5bziHU2Q=;
        b=LFcmg2zrshN6Fds4gMOrG8fLq0xGJzHEE6PUcOgh15TjghtfSB65T2oTspCcxCQGcz+GC2
        +zQ9BQnWPTq4hOrPLYaeZIimdNeSFjkdsSuCM81qkdqCkLYOZKauO+wKO3zShWJn4s+Coq
        DRPKpJtk4KvY/gL6g0e1Vp15QK5PmHY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-53-PoX00jCIO1ylmU18M9Rx-w-1; Tue, 02 Nov 2021 10:59:46 -0400
X-MC-Unique: PoX00jCIO1ylmU18M9Rx-w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4E8D08066F0;
        Tue,  2 Nov 2021 14:59:45 +0000 (UTC)
Received: from localhost (ovpn-8-19.pek2.redhat.com [10.72.8.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BD99A57CAB;
        Tue,  2 Nov 2021 14:59:38 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>, live-patching@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V4 0/3] livepatch: cleanup kpl_patch kobject release
Date:   Tue,  2 Nov 2021 22:59:29 +0800
Message-Id: <20211102145932.3623108-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hello,

The 1st patch moves module_put() to release handler of klp_patch
kobject.

The 2nd patch changes to free klp_patch and other kobjects without
klp_mutex.

The 3rd patch switches to synchronous kobject release for klp_patch.


V4:
	- add freeing klp_patch after klp_enable_patch() returns, since
	patch still can be freed there in case of ->replace is set

V3:
	- one line fix on check of list_empty() in enabled_store(), 3/3

V2:
	- remove enabled attribute before deleting this klp_patch kobject,
	for avoiding deadlock in deleting me


Ming Lei (3):
  livepatch: remove 'struct completion finish' from klp_patch
  livepatch: free klp_patch object without holding klp_mutex
  livepatch: free klp_patch object synchronously

 include/linux/livepatch.h     |  2 -
 kernel/livepatch/core.c       | 73 +++++++++++++++++------------------
 kernel/livepatch/core.h       |  3 +-
 kernel/livepatch/transition.c | 23 ++++++++---
 kernel/livepatch/transition.h |  2 +-
 5 files changed, 54 insertions(+), 49 deletions(-)

-- 
2.31.1

