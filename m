Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B941A13DED0
	for <lists+live-patching@lfdr.de>; Thu, 16 Jan 2020 16:33:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbgAPPcN (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 16 Jan 2020 10:32:13 -0500
Received: from mx2.suse.de ([195.135.220.15]:53726 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726151AbgAPPcN (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 16 Jan 2020 10:32:13 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 25F136A2E1;
        Thu, 16 Jan 2020 15:32:09 +0000 (UTC)
From:   Petr Mladek <pmladek@suse.com>
To:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Nicolai Stange <nstange@suse.de>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Petr Mladek <pmladek@suse.com>
Subject: [PATCH 0/4] livepatch/samples/selftest: Clean up show variables handling
Date:   Thu, 16 Jan 2020 16:31:41 +0100
Message-Id: <20200116153145.2392-1-pmladek@suse.com>
X-Mailer: git-send-email 2.16.4
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Dan Carpenter reported suspicious allocations of shadow variables
in the sample module, see
https://lkml.kernel.org/r/20200107132929.ficffmrm5ntpzcqa@kili.mountain

The code did not cause a real problem. But it was indeed misleading
and semantically wrong. I got confused several times when cleaning it.
So I decided to split the change into few steps. I hope that
it will help reviewers and future readers.

The changes of the sample module are basically the same as in the RFC.
In addition, there is a clean up of the module used by the selftest.


Petr Mladek (4):
  livepatch/sample: Use the right type for the leaking data pointer
  livepatch/selftest: Clean up shadow variable names and type
  livepatch/samples/selftest: Use klp_shadow_alloc() API correctly
  livepatch: Handle allocation failure in the sample of shadow variable
    API

 lib/livepatch/test_klp_shadow_vars.c      | 119 +++++++++++++++++-------------
 samples/livepatch/livepatch-shadow-fix1.c |  39 ++++++----
 samples/livepatch/livepatch-shadow-fix2.c |   4 +-
 samples/livepatch/livepatch-shadow-mod.c  |   4 +-
 4 files changed, 99 insertions(+), 67 deletions(-)

-- 
2.16.4

