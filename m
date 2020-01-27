Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62C0E14A6B0
	for <lists+live-patching@lfdr.de>; Mon, 27 Jan 2020 15:59:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729347AbgA0O7n (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 27 Jan 2020 09:59:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:46496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726443AbgA0O7n (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 27 Jan 2020 09:59:43 -0500
Received: from pobox.suse.cz (prg-ext-pat.suse.com [213.151.95.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A75C215A4;
        Mon, 27 Jan 2020 14:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580137182;
        bh=YYrfflvCXkGkXIlAe9YreqE3Q6fSlLm0zr6pLY2c9IM=;
        h=Date:From:To:cc:Subject:From;
        b=o+F6XV/LWB/hPf6IUEN6//rfnFPylXXE6d6qo4173QFhyU88e3a0gxGqrDmtPubLh
         N6x0DSj4hJG/uj5WZ9ixeAvyNvh2jXjC01SlPzf+L2X6C6K7mSy61PGBGF0YGPvQPP
         kmvHC/cp8+IDqYjcJS11W43+AsR15OvVmH+CjJRQ=
Date:   Mon, 27 Jan 2020 15:59:38 +0100 (CET)
From:   Jiri Kosina <jikos@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
cc:     linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        Miroslav Benes <mbenes@suse.cz>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>
Subject: [GIT PULL] livepatching for 5.6
Message-ID: <nycvar.YFH.7.76.2001271556370.31058@cbobk.fhfr.pm>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Linus,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching.git for-linus

to receive livepatching subsystem updates for 5.6 merge window.

=====
- fixes of selftests and samples for 'shadow variables' livepatching 
  feature, from Petr Mladek
=====

----------------------------------------------------------------
Petr Mladek (4):
      livepatch/sample: Use the right type for the leaking data pointer
      livepatch/selftest: Clean up shadow variable names and type
      livepatch/samples/selftest: Use klp_shadow_alloc() API correctly
      livepatch: Handle allocation failure in the sample of shadow variable API

 lib/livepatch/test_klp_shadow_vars.c      | 119 +++++++++++++++++-------------
 samples/livepatch/livepatch-shadow-fix1.c |  39 ++++++----
 samples/livepatch/livepatch-shadow-fix2.c |   4 +-
 samples/livepatch/livepatch-shadow-mod.c  |   4 +-
 4 files changed, 99 insertions(+), 67 deletions(-)

-- 
Jiri Kosina
SUSE Labs
