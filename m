Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6644B9D23C
	for <lists+live-patching@lfdr.de>; Mon, 26 Aug 2019 17:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729648AbfHZPCN (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 26 Aug 2019 11:02:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58382 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727031AbfHZPCN (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 26 Aug 2019 11:02:13 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 27FDB308FBA7;
        Mon, 26 Aug 2019 15:02:13 +0000 (UTC)
Received: from treble (ovpn-121-55.rdu2.redhat.com [10.10.121.55])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7CF5D60BEC;
        Mon, 26 Aug 2019 15:02:05 +0000 (UTC)
Date:   Mon, 26 Aug 2019 10:02:03 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Nicolai Stange <nstange@suse.de>
Cc:     Miroslav Benes <mbenes@suse.cz>, jikos@kernel.org,
        pmladek@suse.com, joe.lawrence@redhat.com,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] livepatch: Clear relocation targets on a module
 removal
Message-ID: <20190826150203.vg6z3cz54gdt7qs2@treble>
References: <20190719122840.15353-1-mbenes@suse.cz>
 <20190719122840.15353-3-mbenes@suse.cz>
 <20190728200427.dbrojgu7hafphia7@treble>
 <alpine.LSU.2.21.1908141256150.16696@pobox.suse.cz>
 <20190814151244.5xoaxib5iya2qjco@treble>
 <878srgkpmy.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <878srgkpmy.fsf@suse.de>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Mon, 26 Aug 2019 15:02:13 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, Aug 26, 2019 at 03:44:21PM +0200, Nicolai Stange wrote:
> Josh Poimboeuf <jpoimboe@redhat.com> writes:
> 
> > On Wed, Aug 14, 2019 at 01:06:09PM +0200, Miroslav Benes wrote:
> >> > Really, we should be going in the opposite direction, by creating module
> >> > dependencies, like all other kernel modules do, ensuring that a module
> >> > is loaded *before* we patch it.  That would also eliminate this bug.
> >> 
> >> Yes, but it is not ideal either with cumulative one-fixes-all patch 
> >> modules. It would load also modules which are not necessary for a 
> >> customer and I know that at least some customers care about this. They 
> >> want to deploy only things which are crucial for their systems.
> 
> Security concerns set aside, some of the patched modules might get
> distributed separately from the main kernel through some sort of
> kernel-*-extra packages and thus, not be found on some target system
> at all. Or they might have been blacklisted.

True.

> > If you frame the question as "do you want to destabilize the live
> > patching infrastucture" then the answer might be different.
> >
> > We should look at whether it makes sense to destabilize live patching
> > for everybody, for a small minority of people who care about a small
> > minority of edge cases.
> >
> > Or maybe there's some other solution we haven't thought about, which
> > fits more in the framework of how kernel modules already work.
> >
> >> We could split patch modules as you proposed in the past, but that have 
> >> issues as well.
> >
> > Right, I'm not really crazy about that solution either.
> >
> > Here's another idea: per-object patch modules.  Patches to vmlinux are
> > in a vmlinux patch module.  Patches to kvm.ko are in a kvm patch module.
> > That would require:
> >
> > - Careful management of dependencies between object-specific patches.
> >   Maybe that just means that exported function ABIs shouldn't change.
> >
> > - Some kind of hooking into modprobe to ensure the patch module gets
> >   loaded with the real one.
> >
> > - Changing 'atomic replace' to allow patch modules to be per-object.
> >
> 
> Perhaps I'm misunderstanding, but supporting only per-object livepatch
> modules would make livepatch creation for something like commit
> 15fab63e1e57 ("fs: prevent page refcount overflow in pipe_buf_get"),
> CVE-2019-11487 really cumbersome (see the fuse part)?

Just don't change exported interfaces.

In this case you could leave generic_pipe_buf_get() alone and then
instead add a generic_pipe_buf_get__patched() which is called by the
patched fuse module.  If you build the fuse-specific livepatch module
right, it would automatically have a dependency on the vmlinux-specific
livepatch module.

> I think I've seen similar interdependencies between e.g. kvm.ko <->
> kvm_intel.ko, but can't find an example right now.

-- 
Josh
