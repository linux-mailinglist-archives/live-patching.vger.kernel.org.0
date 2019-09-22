Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA07BABBD
	for <lists+live-patching@lfdr.de>; Sun, 22 Sep 2019 22:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726102AbfIVU4r (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sun, 22 Sep 2019 16:56:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:36578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725850AbfIVU4q (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Sun, 22 Sep 2019 16:56:46 -0400
Received: from pobox.suse.cz (prg-ext-pat.suse.com [213.151.95.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43F2C20830;
        Sun, 22 Sep 2019 20:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569185806;
        bh=59wOortf1ia6GCf0XzXP6PHCxVBc1jNNdR79lUWMSjY=;
        h=Date:From:To:cc:Subject:From;
        b=gbAJp/1IXLnfzZttwMbF9TQQWzhn0uImjCBYnezjqoS2FF5kM12i2ui2w0fvnURuz
         UisAdkTgRdJxFwNYQI8jwauzGJKY0VSyqYqmd9sH+e2rt0SM32abR01T732bUOi1W6
         UacOG0SAerAStoar150KSrXU0PIrJ/ZzbwgXJCDE=
Date:   Sun, 22 Sep 2019 22:56:23 +0200 (CEST)
From:   Jiri Kosina <jikos@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] livepatching for 5.4
Message-ID: <nycvar.YFH.7.76.1909222252260.1459@cbobk.fhfr.pm>
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

to receive livepatching subsystem update:

=====
- error handling fix in livepatching module notifier, from Miroslav Benes
=====

Thanks.

----------------------------------------------------------------
Miroslav Benes (1):
      livepatch: Nullify obj->mod in klp_module_coming()'s error path

 kernel/livepatch/core.c | 1 +
 1 file changed, 1 insertion(+)

-- 
Jiri Kosina
SUSE Labs

