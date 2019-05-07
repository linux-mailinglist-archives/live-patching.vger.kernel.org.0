Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64B0D16312
	for <lists+live-patching@lfdr.de>; Tue,  7 May 2019 13:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbfEGLub (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 7 May 2019 07:50:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:48220 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726276AbfEGLub (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 7 May 2019 07:50:31 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 53148AEC2;
        Tue,  7 May 2019 11:50:30 +0000 (UTC)
Date:   Tue, 7 May 2019 13:50:29 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] livepatch: Use static buffer for debugging
 messages under rq lock
Message-ID: <20190507115029.54qxbsd4vsouwvjo@pathway.suse.cz>
References: <20190430091049.30413-1-pmladek@suse.com>
 <20190430091049.30413-3-pmladek@suse.com>
 <20190507004319.oxxncicid6pxg352@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190507004319.oxxncicid6pxg352@treble>
User-Agent: NeoMutt/20170912 (1.9.0)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon 2019-05-06 19:43:19, Josh Poimboeuf wrote:
> On Tue, Apr 30, 2019 at 11:10:49AM +0200, Petr Mladek wrote:
> > klp_try_switch_task() is called under klp_mutex. The buffer for
> > debugging messages might be static.
> 
> The patch description is missing a "why" (presumably to reduce stack
> usage).

Exactly. I thought that it was obvious. But I am infected by printk
code where line buffers are 1k and nobody wants them on the stack.

128bytes in klp_try_switch_task() context are acceptable but
it is still rather big buffer.

OK, what about the following commit message?

"klp_try_switch_task() is called under klp_mutex. The buffer for
debugging messages might be static to reduce stack usage."

Best Regards,
Petr
