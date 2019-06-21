Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FD6B4E8C7
	for <lists+live-patching@lfdr.de>; Fri, 21 Jun 2019 15:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726070AbfFUNTh (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 21 Jun 2019 09:19:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49362 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725974AbfFUNTh (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 21 Jun 2019 09:19:37 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B138D4627A;
        Fri, 21 Jun 2019 13:19:36 +0000 (UTC)
Received: from redhat.com (ovpn-121-168.rdu2.redhat.com [10.10.121.168])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CCBE65D9D2;
        Fri, 21 Jun 2019 13:19:35 +0000 (UTC)
Date:   Fri, 21 Jun 2019 09:19:32 -0400
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Nicolai Stange <nstange@suse.de>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/5] livepatch: new API to track system state changes
Message-ID: <20190621131932.GA20356@redhat.com>
References: <20190611135627.15556-1-pmladek@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190611135627.15556-1-pmladek@suse.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Fri, 21 Jun 2019 13:19:36 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Jun 11, 2019 at 03:56:22PM +0200, Petr Mladek wrote:
> Hi,
> 
> this is another piece in the puzzle that helps to maintain more
> livepatches.
> 
> Especially pre/post (un)patch callbacks might change a system state.
> Any newly installed livepatch has to somehow deal with system state
> modifications done be already installed livepatches.
> 
> This patchset provides, hopefully, a simple and generic API that
> helps to keep and pass information between the livepatches.
> It is also usable to prevent loading incompatible livepatches.
>

Thanks for posting, Petr and aplogies for not getting to this RFC
earlier.  I think this strikes a reasonable balance between the (too) 
"simplified" versioning scheme that I posted a few weeks back, and what
I was afraid might have been too complicated callback-state-version
concept.

This RFC reads fairly straightforward and especially easy to review
given the included documentation and self-tests.  I'll add a few
comments per patch, but again, I like how this came out.
 
> There was also a related idea to add a sticky flag. It should be
> easy to add it later. It would perfectly fit into the new struct
> klp_state.

I think so, too.  It would indicate that the patch is introducing a
state which cannot be safely unloaded.  But we can talk about that at a
later time if/when we want to add that wrinkle to klp_state.
 
-- Joe
