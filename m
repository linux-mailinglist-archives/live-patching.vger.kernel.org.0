Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 739CF43E165
	for <lists+live-patching@lfdr.de>; Thu, 28 Oct 2021 14:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbhJ1NAd (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 28 Oct 2021 09:00:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30316 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230093AbhJ1NAd (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 28 Oct 2021 09:00:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635425885;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=RLyubtvxjGpeEnTLp10d70mgW+REwGQNEyC836W4VCQ=;
        b=A99wx56CIC7XvsX+kehqYGxvlAWdI6kzbAm4rBQwQOU/FLApGPxmcfdCu0WyYNst90kAKz
        hAWm5Il9mG6dLBi4gVE8iGDkGTjcNsdmBYoz3V3xBMm6u/xQbd64vgIelrHSl4SEIloyMC
        gVmFcO4ddumLoIQ5xzmjUcOa5w8nlNk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-188-kqPdrAPOPdC5wC-EgQAYiA-1; Thu, 28 Oct 2021 08:58:02 -0400
X-MC-Unique: kqPdrAPOPdC5wC-EgQAYiA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 14DAA19067F2;
        Thu, 28 Oct 2021 12:57:45 +0000 (UTC)
Received: from localhost (ovpn-8-40.pek2.redhat.com [10.72.8.40])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4D6C65D9DE;
        Thu, 28 Oct 2021 12:57:43 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>, live-patching@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 0/3] livepatch: cleanup kpl_patch kobject release
Date:   Thu, 28 Oct 2021 20:57:31 +0800
Message-Id: <20211028125734.3134176-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hello,

The 1st patch moves module_put() to release handler of klp_patch
kobject.

The 2nd patch changes to free klp_patch and other kobjects without
klp_mutex.

The 3rd patch switches to synchronous kobject release for klp_patch.


Ming Lei (3):
  livepatch: remove 'struct completion finish' from klp_patch
  livepatch: free klp_patch object without holding klp_mutex
  livepatch: free klp_patch object synchronously

 include/linux/livepatch.h     |  2 --
 kernel/livepatch/core.c       | 63 +++++++++++++++--------------------
 kernel/livepatch/core.h       |  3 +-
 kernel/livepatch/transition.c | 23 +++++++++----
 kernel/livepatch/transition.h |  2 +-
 5 files changed, 46 insertions(+), 47 deletions(-)

-- 
2.31.1

