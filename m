Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 347B3313819
	for <lists+live-patching@lfdr.de>; Mon,  8 Feb 2021 16:37:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233394AbhBHPgo (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 8 Feb 2021 10:36:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:36492 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230490AbhBHPef (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 8 Feb 2021 10:34:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612798386;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gg+S9OF2FeNhBwYh2FsUw8uSn6rQJ+TaKCRN/fl/paY=;
        b=DW1ki51gRCfqhlcS6YlN7Es5VizdYFVQhxjONjEFo8JBQevjlejcMvUaFpA53NFkm26s6t
        gmmJE/y5Cta5EH4LBuTubH1UJfd2uxmMnZo6q0k9mUgN0JBDlE6AkOsjJNTLOfVwm4/kfC
        EnNn2m4Ld0150BEodVMz5qYbKutOZSc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-100-cDQmanLKO2ibwJ3RVV6koA-1; Mon, 08 Feb 2021 10:33:04 -0500
X-MC-Unique: cDQmanLKO2ibwJ3RVV6koA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5458180196E;
        Mon,  8 Feb 2021 15:33:03 +0000 (UTC)
Received: from treble (ovpn-113-27.rdu2.redhat.com [10.10.113.27])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 368765C1D0;
        Mon,  8 Feb 2021 15:33:02 +0000 (UTC)
Date:   Mon, 8 Feb 2021 09:33:00 -0600
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@suse.de>,
        Dave Hansen <dave.hansen@intel.com>, x86-ml <x86@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        live-patching@vger.kernel.org
Subject: Re: [GIT PULL] x86/urgent for v5.11-rc7
Message-ID: <20210208153300.m5skwcxxrdpo37iz@treble>
References: <20210207104022.GA32127@zn.tnic>
 <CAHk-=widXSyJ8W3vRrqO-zNP12A+odxg2J2_-oOUskz33wtfqA@mail.gmail.com>
 <20210207175814.GF32127@zn.tnic>
 <CAHk-=wi5z9S7x94SKYNj6qSHBqz+OD76GW=MDzo-KN2Fzm-V4Q@mail.gmail.com>
 <20210207224540.ercf5657pftibyaw@treble>
 <20210208100206.3b74891e@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210208100206.3b74891e@gandalf.local.home>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, Feb 08, 2021 at 10:02:06AM -0500, Steven Rostedt wrote:
> On Sun, 7 Feb 2021 16:45:40 -0600
> Josh Poimboeuf <jpoimboe@redhat.com> wrote:
> 
> > > I do suspect involved people should start thinking about how they want
> > > to deal with functions starting with
> > > 
> > >         endbr64
> > >         call __fentry__
> > > 
> > > instead of the call being at the very top of the function.  
> > 
> > FWIW, objtool's already fine with it (otherwise we would have discovered
> > the need to disable fcf-protection much sooner).
> 
> And this doesn't really affect tracing (note, another user that might be
> affected is live kernel patching).

Good point, livepatch is indeed affected.  Is there a better way to get
the "call __fentry__" address for a given function?


/*
 * Convert a function address into the appropriate ftrace location.
 *
 * Usually this is just the address of the function, but on some architectures
 * it's more complicated so allow them to provide a custom behaviour.
 */
#ifndef klp_get_ftrace_location
static unsigned long klp_get_ftrace_location(unsigned long faddr)
{
	return faddr;
}
#endif

-- 
Josh

