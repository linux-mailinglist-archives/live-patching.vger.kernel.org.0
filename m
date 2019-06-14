Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12A3346453
	for <lists+live-patching@lfdr.de>; Fri, 14 Jun 2019 18:37:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726209AbfFNQg5 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 14 Jun 2019 12:36:57 -0400
Received: from mx2.suse.de ([195.135.220.15]:38268 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726063AbfFNQg5 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 14 Jun 2019 12:36:57 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E210FAF58;
        Fri, 14 Jun 2019 16:36:55 +0000 (UTC)
Date:   Fri, 14 Jun 2019 18:36:55 +0200
From:   Libor Pechacek <lpechacek@suse.cz>
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH v4 00/10] klp-convert livepatch build tooling
Message-ID: <20190614163655.GC15002@fm.suse.cz>
References: <20190509143859.9050-1-joe.lawrence@redhat.com>
 <alpine.LSU.2.21.1906131451560.22698@pobox.suse.cz>
 <b1a627a4-3702-9689-6c03-0c2123c06a2d@redhat.com>
 <c9021573-11c6-b576-0aa6-97754c98a06e@redhat.com>
 <20190614083435.uq3mk6mprbatysol@pathway.suse.cz>
 <a0db1cee-8bba-4093-c3ca-4c2fe61b15ba@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a0db1cee-8bba-4093-c3ca-4c2fe61b15ba@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri 14-06-19 10:20:09, Joe Lawrence wrote:
> On 6/14/19 4:34 AM, Petr Mladek wrote:
[...]
> > Anyway, I am curious about one thing. I saw:
> > 
> > function __load_mod() {
> > 	local mod="$1"; shift
> > 
> > 	local msg="% modprobe $mod $*"
> > 	log "${msg%% }"
> > 	ret=$(modprobe "$mod" "$@" 2>&1)
> > 	if [[ "$ret" != "" ]]; then
> > 		die "$ret"
> > 	fi
> > 
> > 	# Wait for module in sysfs ...
> > 	loop_until '[[ -e "/sys/module/$mod" ]]' ||
> > 		die "failed to load module $mod"
> > }
> > 
> > Is the waiting for sysfs really necessary here?
> > 
> > Note that it is /sys/module and not /sys/kernel/livepatch/.
> 
> I can't remember if that was just paranoid-protective-bash coding or
> actually required.  Libor provided great feedback on the initial patch
> series that introduced the self-tests, perhaps he remembers.

I don't recall analyzing this spot in detail but looking at it now I don't see
anything wrong with it. While the check is likely superfluous, I'm not against
keeping it in place.

> > My understanding is that modprobe waits until the module succesfully
> > loaded. mod_sysfs_setup() is called before the module init callback.
> > Therefore the sysfs interface should be read before modprobe returns.
> > Do I miss something?
> >
> > If it works different way then there might be some races because
> > mod_sysfs_setup() is called before the module is alive.
> 
> All of this is called from a single bash script function, so in a call stack
> fashion, something like this would occur when loading a livepatch module:
> 
>   [ mod_sysfs_setup() ]
>   modprobe waits for:         .init complete, MODULE_STATE_LIVE
>   __load_mod() waits for:     /sys/module/$mod
>   load_lp_nowait() waits for: /sys/kernel/livepatch/$mod
>   load_lp() waits for:        /sys/kernel/livepatch/$mod/transition = 0
>   test-script.sh
> 
> So I would think that by calling modprobe, we ensure that the module code is
> ready to go.  The /sys/module/$mod check might be redundant as you say, but
> because modprobe completed, we should be safe, no?
> 
> The only "nowait" function we have is load_lp_nowait(), which would let us
> march onward before the livepatch transition may have completed.

And even that one is waiting for the live patch module name appear under
/sys/kernel/livepatch/. This is IMHO acceptable level of paranoia.

Libor
-- 
Libor Pechacek
SUSE Labs
