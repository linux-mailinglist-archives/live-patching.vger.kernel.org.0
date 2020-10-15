Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0DDF28F8A9
	for <lists+live-patching@lfdr.de>; Thu, 15 Oct 2020 20:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730494AbgJOScA (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 15 Oct 2020 14:32:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:32864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730461AbgJOSb7 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 15 Oct 2020 14:31:59 -0400
Received: from pobox.suse.cz (nat1.prg.suse.com [195.250.132.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9ED03206B6;
        Thu, 15 Oct 2020 18:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602786719;
        bh=QIEcyyIynUrELEiAlqt0aVNgGRJvQPp7jpGWp5yNelU=;
        h=Date:From:To:cc:Subject:From;
        b=ZkYTN3HzUR8w0FsPn5McquEn/xS12YWxUn3oSnhjBy5YffnCqD8hLFdmsILZ7fwAt
         OIfZZxy20aBJFdu1OaeEn17uAzV4DX5CQIKqYGhSWhWUAMe7Jqs2OJcOE4Avbd7H7p
         Za7rxXVEGqfluKPw1CjgWWmXp1/6G8Qow2ZX74Is=
Date:   Thu, 15 Oct 2020 20:31:55 +0200 (CEST)
From:   Jiri Kosina <jikos@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] livepatching for 5.10
Message-ID: <nycvar.YFH.7.76.2010151950140.18859@cbobk.fhfr.pm>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Linus,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching for-linus

to receive livepatching update for 5.10.

=====
- livepatching kselftest output fix from Miroslav Benes
=====

Thanks.

----------------------------------------------------------------
Miroslav Benes (1):
      selftests/livepatch: Do not check order when using "comm" for dmesg checking

 tools/testing/selftests/livepatch/functions.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
Jiri Kosina
SUSE Labs

