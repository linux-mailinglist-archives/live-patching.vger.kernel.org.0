Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 091BC14B78
	for <lists+live-patching@lfdr.de>; Mon,  6 May 2019 16:04:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725883AbfEFOEW (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 6 May 2019 10:04:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:33098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725852AbfEFOEW (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 6 May 2019 10:04:22 -0400
Received: from pobox.suse.cz (prg-ext-pat.suse.com [213.151.95.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2ED632054F;
        Mon,  6 May 2019 14:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557151462;
        bh=Alhp1xh6c5yPvi0KstiCK8Z6FeOcbLPZWQMtMnppqj4=;
        h=Date:From:To:cc:Subject:From;
        b=fL9EVUqehUPqmZqfVyAkzY3c33niQapg3sfFGsqxQxfQH8orzIa7jibyR1Le9Vcdh
         bXl8Q6IIbAQrkVtbvGGcXMo9nf1gGm4bBv/7iPjTfgpFfaWoo8z0ulqBBZ9o7Hi9vd
         vENQT/Ne4pKA8BNOR5cBW3ekBKysuo6GG/y+5mdE=
Date:   Mon, 6 May 2019 16:04:19 +0200 (CEST)
From:   Jiri Kosina <jikos@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
cc:     linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Subject: [GIT PULL] livepatching for 5.2
Message-ID: <nycvar.YFH.7.76.1905061556400.17054@cbobk.fhfr.pm>
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

to receive livepatching updates for 5.2 merge window. Highlights:

=====
- livepatching kselftests improvements from Joe Lawrence and Miroslav 
  Benes
- making use of gcc's -flive-patching option when available, from
  Miroslav Benes
- kobject handling cleanups, from Petr Mladek
=====

Thanks.

----------------------------------------------------------------
Joe Lawrence (1):
      selftests/livepatch: use TEST_PROGS for test scripts

Miroslav Benes (2):
      kbuild: use -flive-patching when CONFIG_LIVEPATCH is enabled
      selftests/livepatch: Add functions.sh to TEST_PROGS_EXTENDED

Petr Mladek (3):
      livepatch: Convert error about unsupported reliable stacktrace into a warning
      livepatch: Remove custom kobject state handling
      livepatch: Remove duplicated code for early initialization

 Makefile                                   |  4 ++
 include/linux/livepatch.h                  |  3 -
 kernel/livepatch/core.c                    | 91 +++++++++++++-----------------
 tools/testing/selftests/livepatch/Makefile |  3 +-
 4 files changed, 45 insertions(+), 56 deletions(-)

-- 
Jiri Kosina
SUSE Labs

