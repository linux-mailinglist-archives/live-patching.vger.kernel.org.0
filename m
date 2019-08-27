Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0139B9E10C
	for <lists+live-patching@lfdr.de>; Tue, 27 Aug 2019 10:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732087AbfH0IIc (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 27 Aug 2019 04:08:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:38148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731725AbfH0IIb (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 27 Aug 2019 04:08:31 -0400
Received: from pobox.suse.cz (prg-ext-pat.suse.com [213.151.95.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25E53204EC;
        Tue, 27 Aug 2019 08:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566893310;
        bh=t71QLTAx84X+21Pc1uBiXkWoGOOaMZ5pvtPLsqymM6A=;
        h=Date:From:To:cc:Subject:From;
        b=GxlaExQ4Clmjxdcb2K01HJJk72jxrLVZcHsRSqJUAKvTZeyE4EUimuUTULGCdOAca
         yCCMuSBnVMAnm5YPmr61lwRI85X/oLcX1CK67JK//6U0qDchhwvriSe0cHyavZLZQx
         mgWgFKnh/l4D5LZJlBAFAhECj03QmDGbYp+HsSJM=
Date:   Tue, 27 Aug 2019 10:08:17 +0200 (CEST)
From:   Jiri Kosina <jikos@kernel.org>
To:     Petr Mladek <pmladek@suse.cz>, Nicolai Stange <nstange@suse.de>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Miroslav Benes <mbenes@suse.de>,
        Alice Ferrazzi <alicef@gentoo.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
cc:     live-patching@vger.kernel.org
Subject: Live patching MC preliminary schedule
Message-ID: <nycvar.YFH.7.76.1908271005260.27147@cbobk.fhfr.pm>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi,

I've created a preliminary schedule of live patching MC at LPC; it can be 
seen here:

	https://linuxplumbersconf.org/event/4/sessions/47/#20190911

Please take a look, and let me know in case you'd like to request any 
modification of the schedule.

Thanks, and looking forward to seeing you all in Lisbon,

-- 
Jiri Kosina
SUSE Labs

