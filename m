Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7E4D24C4
	for <lists+live-patching@lfdr.de>; Thu, 10 Oct 2019 11:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389995AbfJJIui (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 10 Oct 2019 04:50:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:44292 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390001AbfJJIuh (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 10 Oct 2019 04:50:37 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E6965AD7B;
        Thu, 10 Oct 2019 08:50:35 +0000 (UTC)
Date:   Thu, 10 Oct 2019 10:50:35 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     jikos@kernel.org, Joe Lawrence <joe.lawrence@redhat.com>,
        jpoimboe@redhat.com, mingo@redhat.com,
        Miroslav Benes <mbenes@suse.cz>, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org
Subject: Re: [PATCH 0/3] ftrace: Introduce PERMANENT ftrace_ops flag
Message-ID: <20191010085035.emsdks6xecazqc6k@pathway.suse.cz>
References: <20191007081714.20259-1-mbenes@suse.cz>
 <20191008193534.GA16675@redhat.com>
 <20191009112234.bi7lvp4pvmna26vz@pathway.suse.cz>
 <20191009102654.501ad7c3@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191009102654.501ad7c3@gandalf.local.home>
User-Agent: NeoMutt/20170912 (1.9.0)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed 2019-10-09 10:26:54, Steven Rostedt wrote:
> Petr Mladek <pmladek@suse.com> wrote:
> I think Joe's approach is much easier to understand and implement. The
> "ftrace_enabled" is a global flag, and affects all things ftrace (the
> function bindings). What this patch was doing, was what you said. Make
> ftrace_enabled only affect the ftrace_ops without the "PERMANENT" flag
> set. But that is complex and requires a bit more accounting in the
> ftrace system. Something I think we should try to avoid.

From my POV, the fact that livepatches make use of ftrace handlers
is just an implementation detail. Ideally, users should not know
about it. The livepatch handlers should be handled special way
and should not be affected by the ftrace sysfs interface.
And ideally, the ftrace sysfs interface should still be available
for other ftrace users.

I would understand if this would be too complicated and we would
need to find a compromise.

> What we are now proposing, is that if "ftrace_enabled" is not set, the
> register_ftrace_function() will fail if the ftrace_ops passed to it has
> the PERMANENT flag set (which would cause live patching to fail to
> load).

From the livepatch point of view it would be more reliable if
ftrace_ops with PERMANENT flag would force "ftrace_enabled"
to be always true.

It will make the flag unusable for other ftrace users. But it
will be already be the case when it can't be disabled.

Best Regards,
Petr
