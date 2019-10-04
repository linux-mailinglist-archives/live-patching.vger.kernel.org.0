Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5CD7CBD81
	for <lists+live-patching@lfdr.de>; Fri,  4 Oct 2019 16:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389260AbfJDOjG (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 4 Oct 2019 10:39:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49256 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388982AbfJDOjG (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 4 Oct 2019 10:39:06 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B150E30860D5;
        Fri,  4 Oct 2019 14:39:05 +0000 (UTC)
Received: from redhat.com (ovpn-122-165.rdu2.redhat.com [10.10.122.165])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3EDD960600;
        Fri,  4 Oct 2019 14:39:04 +0000 (UTC)
Date:   Fri, 4 Oct 2019 10:39:01 -0400
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Nicolai Stange <nstange@suse.de>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/5] livepatch: new API to track system state changes
Message-ID: <20191004143901.GA3768@redhat.com>
References: <20191003090137.6874-1-pmladek@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191003090137.6874-1-pmladek@suse.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Fri, 04 Oct 2019 14:39:05 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Oct 03, 2019 at 11:01:32AM +0200, Petr Mladek wrote:
> Hi,
> 
> this is another piece in the puzzle that helps to maintain more
> livepatches.
> 
> Especially pre/post (un)patch callbacks might change a system state.
> Any newly installed livepatch has to somehow deal with system state
> modifications done be already installed livepatches.
> 
> This patchset provides a simple and generic API that
> helps to keep and pass information between the livepatches.
> It is also usable to prevent loading incompatible livepatches.
> 
> Changes since v2:
> 
>   + Typo fixes [Miroslav]
>   + Move the documentation at the end of the list [Miroslav]
>   + Add Miroslav's acks
> 
> Changes since v1:
> 
>   + Use "unsigned long" instead of "int" for "state.id" [Nicolai]
>   + Use "unsigned int" instead of "int" for "state.version [Petr]
>   + Include "state.h" to avoid warning about non-static func [Miroslav]
>   + Simplify logic in klp_is_state_compatible() [Miroslav]
>   + Document how livepatches should handle the state [Nicolai]
>   + Fix some typos, formulation, module metadata [Joe, Miroslav]
> 
> Petr Mladek (5):
>   livepatch: Keep replaced patches until post_patch callback is called
>   livepatch: Basic API to track system state changes
>   livepatch: Allow to distinguish different version of system state
>     changes
>   livepatch: Documentation of the new API for tracking system state
>     changes
>   livepatch: Selftests of the API for tracking system state changes
> 
>  Documentation/livepatch/index.rst               |   1 +
>  Documentation/livepatch/system-state.rst        | 167 +++++++++++++++++++++
>  include/linux/livepatch.h                       |  17 +++
>  kernel/livepatch/Makefile                       |   2 +-
>  kernel/livepatch/core.c                         |  44 ++++--
>  kernel/livepatch/core.h                         |   5 +-
>  kernel/livepatch/state.c                        | 122 +++++++++++++++
>  kernel/livepatch/state.h                        |   9 ++
>  kernel/livepatch/transition.c                   |  12 +-
>  lib/livepatch/Makefile                          |   5 +-
>  lib/livepatch/test_klp_state.c                  | 161 ++++++++++++++++++++
>  lib/livepatch/test_klp_state2.c                 | 190 ++++++++++++++++++++++++
>  lib/livepatch/test_klp_state3.c                 |   5 +
>  tools/testing/selftests/livepatch/Makefile      |   3 +-
>  tools/testing/selftests/livepatch/test-state.sh | 180 ++++++++++++++++++++++
>  15 files changed, 902 insertions(+), 21 deletions(-)
>  create mode 100644 Documentation/livepatch/system-state.rst
>  create mode 100644 kernel/livepatch/state.c
>  create mode 100644 kernel/livepatch/state.h
>  create mode 100644 lib/livepatch/test_klp_state.c
>  create mode 100644 lib/livepatch/test_klp_state2.c
>  create mode 100644 lib/livepatch/test_klp_state3.c
>  create mode 100755 tools/testing/selftests/livepatch/test-state.sh
> 
> -- 
> 2.16.4
> 

Hi Petr,

Thanks for respinning this one with the latest updates.  The
implementation looks fine to me.  I have two really minor nits for the
selftest (I'll reply to that commit), but I wouldn't hold up the series
for them.

Acked-by: Joe Lawrence <joe.lawrence@redhat.com>

-- Joe
