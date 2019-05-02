Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBEB7111A4
	for <lists+live-patching@lfdr.de>; Thu,  2 May 2019 04:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbfEBCkT (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 1 May 2019 22:40:19 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:47459 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726386AbfEBCj7 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 1 May 2019 22:39:59 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 2948A658;
        Wed,  1 May 2019 22:32:32 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 01 May 2019 22:32:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=g7oDYn0FII0T/Yixf
        mxwmi9xKUU1gQhrv1XNZ2l/Aog=; b=1AlxjvtWqz6uPLhuiKS/7HT1o57XrVoP9
        jBiYitao8Glgghf9QiX9Qlmqfa3BP99WSImI08GgertYCmAA4ZSa5opbhkepI8z/
        kC7K2bPocryh5UANj4Tv0S/eE14SNAdmWksd6FXXdgjjaJrDVtZvkZRoU71EKoc8
        FfMCbhfZyQLHaLPp3bI6epvNBcFaI75v0yDfn6EC4a5Mqyk6VZ9Pp+9aH6fVI0Zq
        4rXg1tnryb/V+Obk2B0ni17Wcvkuw4eNPmKXw/P6xXXPEwRP0HNrq7HT51duw/do
        JdL+9S99Lrlf0yDxXATcnUVpAcMo//Wfm3Q+o2IJigl34GenhWhXA==
X-ME-Sender: <xms:vlbKXLv_p91ClTqjEGTIKVr6EQoj7FVdXQAsVQcfTdT5sYb14T4AgQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrieekgdehtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgggfestdekredtredttdenucfhrhhomhepfdfvohgsihhnucev
    rdcujfgrrhguihhnghdfuceothhosghinheskhgvrhhnvghlrdhorhhgqeenucfkphepud
    dvuddrgeegrddvtdegrddvfeehnecurfgrrhgrmhepmhgrihhlfhhrohhmpehtohgsihhn
    sehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:vlbKXE198qRD5-2msi22zIZW5nYYRYNC-OXDGcbOO3LsFSZe6SL82Q>
    <xmx:vlbKXA_gkou5Ygtm0DLL1Y_Tr1lC4uxE88ijqkifuHRkrrBiugwMog>
    <xmx:vlbKXCASCeRWEmyEodxZpdQbGyq8iAgOhRn81KpBkUKD8eVR2Dexiw>
    <xmx:v1bKXLSmw6-fThuLQ4stDG0aBAx51mOFURnzGOSqlQdLRp2fHecdWw>
Received: from eros.localdomain (ppp121-44-204-235.bras1.syd2.internode.on.net [121.44.204.235])
        by mail.messagingengine.com (Postfix) with ESMTPA id 77E91E407B;
        Wed,  1 May 2019 22:32:27 -0400 (EDT)
From:   "Tobin C. Harding" <tobin@kernel.org>
To:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "Tobin C. Harding" <tobin@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/5] kobject: Add and use init predicate
Date:   Thu,  2 May 2019 12:31:37 +1000
Message-Id: <20190502023142.20139-1-tobin@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi,

This set patches kobject to add a predicate function for determining the
initialization state of a kobject.  Stripped down, the predicate is:

	bool kobject_is_initialized(struct kobject *kobj)
	{
		return kobj->state_initialized
	}

This is RFC because there are merge conflicts with Greg's driver-core
tree.  I'm guessing this is caused by the cleanup patches (#2 and #3).
If the set is deemed likeable then I can re-work the set targeting
whomever's tree this would go in through.

Applies on top of:

	mainline tag: v5.1-rc6
	livepatching branch: for-next

Series Description
------------------
	
Patch #1 is a memleak patch, previously posted and not overly
interesting.  Comment by Greg on the thread on that patch was the
incentive for this series.

Patch #2 and #3 are kobject kernel-doc comment clean ups.  Can be
dropped if not liked.

Patch #4 adds the predicate function to the kobject API.

Patch #5 uses the new predicate to remove the custom logic from livepatch
for tracking kobject initialization state.

Testing
-------

Kernel build configuration

	$ egrep LIVEPATCH .config
	CONFIG_HAVE_LIVEPATCH=y
	CONFIG_LIVEPATCH=y
	CONFIG_TEST_LIVEPATCH=m

	$ egrep FTRACE .config
	CONFIG_KPROBES_ON_FTRACE=y
	CONFIG_HAVE_KPROBES_ON_FTRACE=y
	CONFIG_HAVE_DYNAMIC_FTRACE=y
	CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
	CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
	CONFIG_FTRACE=y
	CONFIG_FTRACE_SYSCALLS=y
	CONFIG_DYNAMIC_FTRACE=y
	CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
	CONFIG_FTRACE_MCOUNT_RECORD=y
	# CONFIG_FTRACE_STARTUP_TEST is not set

Builds fine but doesn't boot in Qemu.  I've never run dynamic Ftrace, it
appears to crash during this.  Was hoping to run the livepatch tests but
not sure how to at this moment.  Is dynamic Ftrace and livepatch testing
something that can even be done in a VM or do I need to do this or
baremetal?

Thanks for taking the time to look at this.

	Tobin


Tobin C. Harding (5):
  livepatch: Fix kobject memleak
  kobject: Remove docstring reference to kset
  kobject: Fix kernel-doc comment first line
  kobject: Add kobject initialized predicate
  livepatch: Do not manually track kobject initialization

 include/linux/kobject.h   |  2 ++
 include/linux/livepatch.h |  6 ----
 kernel/livepatch/core.c   | 28 +++++++++---------
 lib/kobject.c             | 60 +++++++++++++++++++++++----------------
 4 files changed, 51 insertions(+), 45 deletions(-)

-- 
2.21.0

