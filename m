Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18A2737534
	for <lists+live-patching@lfdr.de>; Thu,  6 Jun 2019 15:27:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727709AbfFFN1p (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 6 Jun 2019 09:27:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:35968 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726014AbfFFN1p (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 6 Jun 2019 09:27:45 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 61DACAEB8;
        Thu,  6 Jun 2019 13:27:44 +0000 (UTC)
Date:   Thu, 6 Jun 2019 15:27:43 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] livepatch: Use static buffer for debugging messages
 under rq lock
Message-ID: <20190606132743.sy6viyd6mt7te6ar@pathway.suse.cz>
References: <20190531074147.27616-1-pmladek@suse.com>
 <20190531074147.27616-4-pmladek@suse.com>
 <20190531193908.nltikmafed36iozh@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190531193908.nltikmafed36iozh@treble>
User-Agent: NeoMutt/20170912 (1.9.0)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri 2019-05-31 14:39:08, Josh Poimboeuf wrote:
> On Fri, May 31, 2019 at 09:41:47AM +0200, Petr Mladek wrote:
> > The err_buf array uses 128 bytes of stack space.  Move it off the stack
> > by making it static.  It's safe to use a shared buffer because
> > klp_try_switch_task() is called under klp_mutex.
> > 
> > Signed-off-by: Petr Mladek <pmladek@suse.com>
> > Acked-by: Miroslav Benes <mbenes@suse.cz>
> > Reviewed-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
> 
> Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>

The patch is committed into for-5.3/core branch.

Note that the branch is based on the last merge from livepatch.git.
As a result, the sefttest fails because of the regression in
the reliable stacktrace code.

You might want to base your development on the for-next branch.
Or you chould cherry pick the commit 7eaf51a2e094229b75cc0c31
("[PATCH] stacktrace: Unbreak stack_trace_save_tsk_reliable()").

Best Regards,
Petr

PS: I am leaving the fate of the other two patches into Miroslav's
hands ;-)
