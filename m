Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1947FCBDCE
	for <lists+live-patching@lfdr.de>; Fri,  4 Oct 2019 16:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389283AbfJDOrq (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 4 Oct 2019 10:47:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45326 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388870AbfJDOrq (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 4 Oct 2019 10:47:46 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D55892CD7E5;
        Fri,  4 Oct 2019 14:47:45 +0000 (UTC)
Received: from redhat.com (ovpn-122-165.rdu2.redhat.com [10.10.122.165])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A17E61017CD5;
        Fri,  4 Oct 2019 14:47:44 +0000 (UTC)
Date:   Fri, 4 Oct 2019 10:47:42 -0400
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Nicolai Stange <nstange@suse.de>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 5/5] livepatch: Selftests of the API for tracking
 system state changes
Message-ID: <20191004144742.GB3768@redhat.com>
References: <20191003090137.6874-1-pmladek@suse.com>
 <20191003090137.6874-6-pmladek@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191003090137.6874-6-pmladek@suse.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Fri, 04 Oct 2019 14:47:45 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Oct 03, 2019 at 11:01:37AM +0200, Petr Mladek wrote:
> Four selftests for the new API.
> 
> Signed-off-by: Petr Mladek <pmladek@suse.com>
> Acked-by: Miroslav Benes <mbenes@suse.cz>
> ---
>  lib/livepatch/Makefile                          |   5 +-
>  lib/livepatch/test_klp_state.c                  | 161 ++++++++++++++++++++
>  lib/livepatch/test_klp_state2.c                 | 190 ++++++++++++++++++++++++
>  lib/livepatch/test_klp_state3.c                 |   5 +
>  tools/testing/selftests/livepatch/Makefile      |   3 +-
>  tools/testing/selftests/livepatch/test-state.sh | 180 ++++++++++++++++++++++
>  6 files changed, 542 insertions(+), 2 deletions(-)
>  create mode 100644 lib/livepatch/test_klp_state.c
>  create mode 100644 lib/livepatch/test_klp_state2.c
>  create mode 100644 lib/livepatch/test_klp_state3.c
>  create mode 100755 tools/testing/selftests/livepatch/test-state.sh
> 
> [ ... snip ... ]
> diff --git a/tools/testing/selftests/livepatch/test-state.sh b/tools/testing/selftests/livepatch/test-state.sh
> new file mode 100755
> index 000000000000..1139c664c11c
> --- /dev/null
> +++ b/tools/testing/selftests/livepatch/test-state.sh
> @@ -0,0 +1,180 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (C) 2018 Joe Lawrence <joe.lawrence@redhat.com>
> +

nit: this should probably read as:
# Copyright (C) 2019 Petr Mladek <pmladek@suse.com>

> +. $(dirname $0)/functions.sh
> +
> +MOD_LIVEPATCH=test_klp_state
> +MOD_LIVEPATCH2=test_klp_state2
> +MOD_LIVEPATCH3=test_klp_state3
> +
> +set_dynamic_debug
> +
> +
> +# TEST: Loading and removing a module that modifies the system state
> +
> +echo -n "TEST: system state modification ... "
> +dmesg -C
> +
> +load_lp $MOD_LIVEPATCH
> +disable_lp $MOD_LIVEPATCH
> +unload_lp $MOD_LIVEPATCH
> +
> +check_result "% modprobe test_klp_state
> +livepatch: enabling patch 'test_klp_state'
> +livepatch: 'test_klp_state': initializing patching transition
> +test_klp_state: pre_patch_callback: vmlinux
> +test_klp_state: allocate_loglevel_state: allocating space to store console_loglevel
> +livepatch: 'test_klp_state': starting patching transition
> +livepatch: 'test_klp_state': completing patching transition
> +test_klp_state: post_patch_callback: vmlinux
> +test_klp_state: fix_console_loglevel: fixing console_loglevel
> +livepatch: 'test_klp_state': patching complete
> +% echo 0 > /sys/kernel/livepatch/test_klp_state/enabled
> +livepatch: 'test_klp_state': initializing unpatching transition
> +test_klp_state: pre_unpatch_callback: vmlinux
> +test_klp_state: restore_console_loglevel: restoring console_loglevel
> +livepatch: 'test_klp_state': starting unpatching transition
> +livepatch: 'test_klp_state': completing unpatching transition
> +test_klp_state: post_unpatch_callback: vmlinux
> +test_klp_state: free_loglevel_state: freeing space for the stored console_loglevel
> +livepatch: 'test_klp_state': unpatching complete
> +% rmmod test_klp_state"
> +

nit: a matter of style, and I don't mind either, but the other test
scripts used $MOD_LIVEPATCH{2,3} variable replacement in the
check_result string.  I think I originally did that when we were
reviewing the first self-test patchset and the filenames may or may not
have changed.  Those names are stable now, so I don't have a strong
opinion either way.

FWIW, if someone wants to make the copyright change on merge, I'm cool
with this version.

-- Joe
