Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81739441AA1
	for <lists+live-patching@lfdr.de>; Mon,  1 Nov 2021 12:26:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231437AbhKAL2k (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 1 Nov 2021 07:28:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26282 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232001AbhKAL2k (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 1 Nov 2021 07:28:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635765966;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=KnETWn4ATxLuSMGRTYpAvY2hoOsYqW2nRmiZQxMBcXc=;
        b=d2erFNKXIA0Tm4+Shucu9Y3RLSRrOUBSJGDEfO6C5xkhjDFRoHLlI/xaoOsuKNoaW50KMb
        ZRAEb5sM7iSEJv3XkLezOTmkU41By25VuV/hv42cF1uI31yWQpo2KDFmevCC5nisRfKZlx
        stFraJdAux4Xwg/TAZRC/u3vX+9LTq8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-60-PbsYymxrN6iKvl-3Zjrifg-1; Mon, 01 Nov 2021 07:26:03 -0400
X-MC-Unique: PbsYymxrN6iKvl-3Zjrifg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 46356802682;
        Mon,  1 Nov 2021 11:26:02 +0000 (UTC)
Received: from localhost (ovpn-8-37.pek2.redhat.com [10.72.8.37])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8389B6091B;
        Mon,  1 Nov 2021 11:25:55 +0000 (UTC)
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
Subject: [PATCH V3 0/3] livepatch: cleanup kpl_patch kobject release
Date:   Mon,  1 Nov 2021 19:25:45 +0800
Message-Id: <20211101112548.3364086-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hello,

The 1st patch moves module_put() to release handler of klp_patch
kobject.

The 2nd patch changes to free klp_patch and other kobjects without
klp_mutex.

The 3rd patch switches to synchronous kobject release for klp_patch.


V3:
	- one line fix on check of list_empty() in enabled_store(), 3/3

V2:
	- remove enabled attribute before deleting this klp_patch kobject,
	for avoiding deadlock in deleting me


Ming Lei (3):
  livepatch: remove 'struct completion finish' from klp_patch
  livepatch: free klp_patch object without holding klp_mutex
  livepatch: free klp_patch object synchronously

 include/linux/livepatch.h     |  2 --
 kernel/livepatch/core.c       | 67 ++++++++++++++++-------------------
 kernel/livepatch/core.h       |  3 +-
 kernel/livepatch/transition.c | 23 ++++++++----
 kernel/livepatch/transition.h |  2 +-
 5 files changed, 50 insertions(+), 47 deletions(-)

-- 
2.31.1

