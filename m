Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D59B316471
	for <lists+live-patching@lfdr.de>; Tue,  7 May 2019 15:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726321AbfEGNTQ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 7 May 2019 09:19:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42890 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726426AbfEGNTQ (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 7 May 2019 09:19:16 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 231CE307D91F;
        Tue,  7 May 2019 13:19:16 +0000 (UTC)
Received: from treble (ovpn-123-166.rdu2.redhat.com [10.10.123.166])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0519660C4E;
        Tue,  7 May 2019 13:19:09 +0000 (UTC)
Date:   Tue, 7 May 2019 08:19:07 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] livepatch: Use static buffer for debugging
 messages under rq lock
Message-ID: <20190507131907.ep5g2hi4hp2lvy3d@treble>
References: <20190430091049.30413-1-pmladek@suse.com>
 <20190430091049.30413-3-pmladek@suse.com>
 <20190507004319.oxxncicid6pxg352@treble>
 <20190507115029.54qxbsd4vsouwvjo@pathway.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190507115029.54qxbsd4vsouwvjo@pathway.suse.cz>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Tue, 07 May 2019 13:19:16 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, May 07, 2019 at 01:50:29PM +0200, Petr Mladek wrote:
> On Mon 2019-05-06 19:43:19, Josh Poimboeuf wrote:
> > On Tue, Apr 30, 2019 at 11:10:49AM +0200, Petr Mladek wrote:
> > > klp_try_switch_task() is called under klp_mutex. The buffer for
> > > debugging messages might be static.
> > 
> > The patch description is missing a "why" (presumably to reduce stack
> > usage).
> 
> Exactly. I thought that it was obvious. But I am infected by printk
> code where line buffers are 1k and nobody wants them on the stack.
> 
> 128bytes in klp_try_switch_task() context are acceptable but
> it is still rather big buffer.
> 
> OK, what about the following commit message?
> 
> "klp_try_switch_task() is called under klp_mutex. The buffer for
> debugging messages might be static to reduce stack usage."

It's better to use imperative language.  It would also be good to
reverse the order of the wording by starting with the problem.

Something like:

The err_buf array uses 128 bytes of stack space.  Move it off the stack
by making it static.  It's safe to use a shared buffer because
klp_try_switch_task() is called under klp_mutex.

-- 
Josh
