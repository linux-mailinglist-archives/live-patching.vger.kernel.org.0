Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF338D6FB
	for <lists+live-patching@lfdr.de>; Wed, 14 Aug 2019 17:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726166AbfHNPMt (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 14 Aug 2019 11:12:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35408 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727111AbfHNPMt (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 14 Aug 2019 11:12:49 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 267D3302C067;
        Wed, 14 Aug 2019 15:12:49 +0000 (UTC)
Received: from treble (ovpn-120-159.rdu2.redhat.com [10.10.120.159])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D4CB17AB7E;
        Wed, 14 Aug 2019 15:12:45 +0000 (UTC)
Date:   Wed, 14 Aug 2019 10:12:44 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     jikos@kernel.org, pmladek@suse.com, joe.lawrence@redhat.com,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] livepatch: Clear relocation targets on a module
 removal
Message-ID: <20190814151244.5xoaxib5iya2qjco@treble>
References: <20190719122840.15353-1-mbenes@suse.cz>
 <20190719122840.15353-3-mbenes@suse.cz>
 <20190728200427.dbrojgu7hafphia7@treble>
 <alpine.LSU.2.21.1908141256150.16696@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.1908141256150.16696@pobox.suse.cz>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Wed, 14 Aug 2019 15:12:49 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Aug 14, 2019 at 01:06:09PM +0200, Miroslav Benes wrote:
> > Really, we should be going in the opposite direction, by creating module
> > dependencies, like all other kernel modules do, ensuring that a module
> > is loaded *before* we patch it.  That would also eliminate this bug.
> 
> Yes, but it is not ideal either with cumulative one-fixes-all patch 
> modules. It would load also modules which are not necessary for a 
> customer and I know that at least some customers care about this. They 
> want to deploy only things which are crucial for their systems.

If you frame the question as "do you want to destabilize the live
patching infrastucture" then the answer might be different.

We should look at whether it makes sense to destabilize live patching
for everybody, for a small minority of people who care about a small
minority of edge cases.

Or maybe there's some other solution we haven't thought about, which
fits more in the framework of how kernel modules already work.

> We could split patch modules as you proposed in the past, but that have 
> issues as well.

Right, I'm not really crazy about that solution either.

Here's another idea: per-object patch modules.  Patches to vmlinux are
in a vmlinux patch module.  Patches to kvm.ko are in a kvm patch module.
That would require:

- Careful management of dependencies between object-specific patches.
  Maybe that just means that exported function ABIs shouldn't change.

- Some kind of hooking into modprobe to ensure the patch module gets
  loaded with the real one.

- Changing 'atomic replace' to allow patch modules to be per-object.

> Anyway, that is why I proposed "Rethinking late module patching" talk at 
> LPC and we should try to come up with a solution there.

Thanks, I saw that.  It's definitely worthy of more discussion.  The
talk may be more productive if there were code to look at.  For example,
a patch which removes all the "late module patching" gunk, so we can at
least quantify the cost of the current approach.

-- 
Josh
