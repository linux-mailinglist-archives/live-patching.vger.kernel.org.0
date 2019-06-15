Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD93F47224
	for <lists+live-patching@lfdr.de>; Sat, 15 Jun 2019 22:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725944AbfFOUro (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sat, 15 Jun 2019 16:47:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60838 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725535AbfFOUrn (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Sat, 15 Jun 2019 16:47:43 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9A6222F8BC8;
        Sat, 15 Jun 2019 20:47:43 +0000 (UTC)
Received: from treble (ovpn-112-16.rdu2.redhat.com [10.10.112.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2F05960CA3;
        Sat, 15 Jun 2019 20:47:38 +0000 (UTC)
Date:   Sat, 15 Jun 2019 15:47:36 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Nicolai Stange <nstange@suse.de>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/5] livepatch: new API to track system state changes
Message-ID: <20190615204736.coc2gbgffahkirnz@treble>
References: <20190611135627.15556-1-pmladek@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190611135627.15556-1-pmladek@suse.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Sat, 15 Jun 2019 20:47:43 +0000 (UTC)
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
> There was also a related idea to add a sticky flag. It should be
> easy to add it later. It would perfectly fit into the new struct
> klp_state.
> 
> Petr Mladek (5):
>   livepatch: Keep replaced patches until post_patch callback is called
>   livepatch: Basic API to track system state changes
>   livepatch: Allow to distinguish different version of system state
>     changes
>   livepatch: Documentation of the new API for tracking system state
>     changes
>   livepatch: Selftests of the API for tracking system state changes

I confess I missed most of the previous discussion, but from a first
read-through this seems reasonable, and the code looks simple and
self-contained.

-- 
Josh
