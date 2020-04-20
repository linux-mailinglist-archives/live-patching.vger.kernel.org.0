Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A6DF1B1639
	for <lists+live-patching@lfdr.de>; Mon, 20 Apr 2020 21:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbgDTTvV (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 20 Apr 2020 15:51:21 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:26780 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725897AbgDTTvU (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 20 Apr 2020 15:51:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587412279;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TWPS8Ag7vK66l0A1WZiPeQ8HRASExb1Zd/J41NjFSx4=;
        b=bCQSCeE3kHWNQt8EjEIlXUABatiKDng0YkWPgQjhJCwbSbt7Is0qOK+UMgeye1lBghBeYu
        fNhn+jMhwGTZqegR9qN8OVmz1LC3LQkMQv+tzXmoyvblYAhjuVfgEGTEx7TXuytF6VB6T/
        hfpLGjyUZb05n6iCZ8ExwcNbmeDoIio=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-32-C1aiVMz-M62ucoynYrtO3A-1; Mon, 20 Apr 2020 15:51:17 -0400
X-MC-Unique: C1aiVMz-M62ucoynYrtO3A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A7F4E1922020;
        Mon, 20 Apr 2020 19:51:16 +0000 (UTC)
Received: from treble (ovpn-118-158.rdu2.redhat.com [10.10.118.158])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B98FB9A253;
        Mon, 20 Apr 2020 19:51:13 +0000 (UTC)
Date:   Mon, 20 Apr 2020 14:51:11 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>
Subject: Re: [PATCH v2 2/9] livepatch: Apply vmlinux-specific KLP relocations
 early
Message-ID: <20200420195111.ob7jnhs7wqp6d56g@treble>
References: <cover.1587131959.git.jpoimboe@redhat.com>
 <83eb0be61671eab05e2d7bcd0aa848f6e20087b0.1587131959.git.jpoimboe@redhat.com>
 <20200420175751.GA13807@redhat.com>
 <20200420182516.6awwwbvoen62gwbr@treble>
 <20200420190141.GB13807@redhat.com>
 <20200420191117.wrjauayeutkpvkwd@treble>
 <20200420194900.GC13807@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200420194900.GC13807@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, Apr 20, 2020 at 03:49:00PM -0400, Joe Lawrence wrote:
> On Mon, Apr 20, 2020 at 02:11:17PM -0500, Josh Poimboeuf wrote:
> > On Mon, Apr 20, 2020 at 03:01:41PM -0400, Joe Lawrence wrote:
> > > > > ... apply_relocations() is also iterating over the section headers (the
> > > > > diff context doesn't show it here, but i is an incrementing index over
> > > > > sechdrs[]).
> > > > > 
> > > > > So if there is more than one KLP relocation section, we'll process them
> > > > > multiple times.  At least the x86 relocation code will detect this and
> > > > > fail the module load with an invalid relocation (existing value not
> > > > > zero).
> > > > 
> > > > Ah, yes, good catch!
> > > > 
> > > 
> > > The same test case passed with a small modification to push the foreach
> > > KLP section part to a kernel/livepatch/core.c local function and
> > > exposing the klp_resolve_symbols() + apply_relocate_add() for a given
> > > section to kernel/module.c.  Something like following...
> > 
> > I came up with something very similar, though I named them
> > klp_apply_object_relocs() and klp_apply_section_relocs() and changed the
> > argument order a bit (module first).  Since it sounds like you have a
> > test, could you try this one?
> > 
> 
> LGTM.  I have a few klp-convert selftests that I've been slowly
> tinkering on and they all load/run successfully with this version. :)

Good to hear, thanks!  Hooray selftests :-)

-- 
Josh

