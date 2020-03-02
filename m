Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51013175807
	for <lists+live-patching@lfdr.de>; Mon,  2 Mar 2020 11:12:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727060AbgCBKMK (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 2 Mar 2020 05:12:10 -0500
Received: from mx2.suse.de ([195.135.220.15]:57576 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726874AbgCBKMJ (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 2 Mar 2020 05:12:09 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 09034B02C;
        Mon,  2 Mar 2020 10:12:07 +0000 (UTC)
Date:   Mon, 2 Mar 2020 11:12:07 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     JeffleXu <jefflexu@linux.alibaba.com>
Cc:     jpoimboe@redhat.com, live-patching@vger.kernel.org
Subject: Re: [help] Confusion on livepatch's per-task consistency model
Message-ID: <20200302101207.57i4opglpgaynfju@pathway.suse.cz>
References: <315f87a7-eb40-67a7-4ab9-4b384fde752a@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <315f87a7-eb40-67a7-4ab9-4b384fde752a@linux.alibaba.com>
User-Agent: NeoMutt/20170912 (1.9.0)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon 2020-03-02 16:45:24, JeffleXu wrote:
> Hello guys,
> 
> 
> I'm new to livepatch world and now I'm a little confused with livepatch's
> 
> per-task consistency model which is introduced by [1]. I've also readed the
> 
> discussion on mailing list [2], which introduces shadow variable to handle
> 
> data layout and semantic changes. But there's still some confusion with this
> 
> per-task consistency model.
> 
> 
> According to the model, there will be scenario where old function and new
> 
> function can co-exist, though for a single thread, it sees either all new
> 
> functions or all old functions.
> 
> 
> I can't understand why Vojtech said that 'old func processing new data' was
> 
> impossible. Assuming a scenario where a process calls func-A to submit a
> 
> work request (inserted into a global list), and then a kthread is
> responsible
> 
> for calling func-B to process all work requests in the list. What if this
> process
> 
> has finished the transition (sees new func-A) while kthread still sees the
> old func-B?
> 
> In this case, old func-B has to process new data. If there's some lock
> semantic
> 
> changes in func-A and func-B, then old func-B has no way identifying the
> shadow
> 
> variable labeled by new func-A.
> 
> 
> Please tell me if I missed something, and any suggestions will be
> appreciated. ;)

No, you did not miss anything. The consistency is only per-thread,
If a livepatch is changing semantic of a global variable it must
allow doing the changes only when the entire system is using
the new code. And the new code must be able to deal with both
old and new data.

The new data semantic can be enable by post-patch callback
that is called when the transition has finished.

Fortunately, semantic changes are very rare at least in security
fixes.

Best Regards,
Petr
