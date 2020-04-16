Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1EC41AC111
	for <lists+live-patching@lfdr.de>; Thu, 16 Apr 2020 14:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2635475AbgDPMVV (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 16 Apr 2020 08:21:21 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56277 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2635462AbgDPMVL (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 16 Apr 2020 08:21:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587039670;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vqyaUkx8GR3JwQKbW/npDJYm+9ZLhBx+EmB8q5JLS1g=;
        b=CAABffqOCQNKI5vMzDeR9PIE4RDi/HH1tUV9z9P1oK9Rv1Sa710JHytyAPu1Q7LhkgOWqB
        4KYKXh22vYjUKD9Nzk3dbImVLArCj0kJA9flVuP7huSSVr9y/v5uvvFllnI38cK77ju4Dt
        5cnHlOafZG8XjCsG/hee14LzylStgnA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-438-a-kyZDoHP2eJd_9KW0C3kQ-1; Thu, 16 Apr 2020 08:20:55 -0400
X-MC-Unique: a-kyZDoHP2eJd_9KW0C3kQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4A93C107B765;
        Thu, 16 Apr 2020 12:20:54 +0000 (UTC)
Received: from treble (ovpn-116-146.rdu2.redhat.com [10.10.116.146])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9A7951001902;
        Thu, 16 Apr 2020 12:20:53 +0000 (UTC)
Date:   Thu, 16 Apr 2020 07:20:51 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jessica Yu <jeyu@kernel.org>
Subject: Re: [PATCH 0/7] livepatch,module: Remove .klp.arch and
 module_disable_ro()
Message-ID: <20200416122051.p3dk5i7h6ty4cwuc@treble>
References: <cover.1586881704.git.jpoimboe@redhat.com>
 <20200414182726.GF2483@worktop.programming.kicks-ass.net>
 <20200414190814.glra2gceqgy34iyx@treble>
 <alpine.LSU.2.21.2004161136340.10475@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.2004161136340.10475@pobox.suse.cz>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Apr 16, 2020 at 11:45:05AM +0200, Miroslav Benes wrote:
> On Tue, 14 Apr 2020, Josh Poimboeuf wrote:
> 
> > On Tue, Apr 14, 2020 at 08:27:26PM +0200, Peter Zijlstra wrote:
> > > On Tue, Apr 14, 2020 at 11:28:36AM -0500, Josh Poimboeuf wrote:
> > > > Better late than never, these patches add simplifications and
> > > > improvements for some issues Peter found six months ago, as part of his
> > > > non-writable text code (W^X) cleanups.
> > > 
> > > Excellent stuff, thanks!!
> > >
> > > I'll go brush up these two patches then:
> > > 
> > >   https://lkml.kernel.org/r/20191018074634.801435443@infradead.org
> > >   https://lkml.kernel.org/r/20191018074634.858645375@infradead.org
> > 
> > Ah right, I meant to bring that up.  I actually played around with those
> > patches.  While it would be nice to figure out a way to converge the
> > ftrace module init, I didn't really like the first patch.
> > 
> > It bothers me that both the notifiers and the module init() both see the
> > same MODULE_STATE_COMING state, but only in the former case is the text
> > writable.
> > 
> > I think it's cognitively simpler if MODULE_STATE_COMING always means the
> > same thing, like the comments imply, "fully formed" and thus
> > not-writable:
> > 
> > enum module_state {
> > 	MODULE_STATE_LIVE,	/* Normal state. */
> > 	MODULE_STATE_COMING,	/* Full formed, running module_init. */
> > 	MODULE_STATE_GOING,	/* Going away. */
> > 	MODULE_STATE_UNFORMED,	/* Still setting it up. */
> > };
> > 
> > And, it keeps tighter constraints on what a notifier can do, which is a
> > good thing if we can get away with it.
> 
> Agreed.
> 
> On the other hand, the first patch would remove the tiny race window when 
> a module state is still UNFORMED, but the protections are (being) set up. 
> Patches 4/7 and 5/7 allow to use memcpy in that case, because it is early. 
> But it is in fact not already. I haven't checked yet if it really matters 
> somewhere (a race with livepatch running klp_module_coming while another 
> module is being loaded or anything like that).

Maybe I'm missing your point, but I don't see any races here.

apply_relocate_add() only writes to the patch module's text, so there
can't be races with other modules.

-- 
Josh

