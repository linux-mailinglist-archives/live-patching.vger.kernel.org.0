Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F27C62F692C
	for <lists+live-patching@lfdr.de>; Thu, 14 Jan 2021 19:16:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728281AbhANSLE (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 14 Jan 2021 13:11:04 -0500
Received: from foss.arm.com ([217.140.110.172]:54246 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726625AbhANSLE (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 14 Jan 2021 13:11:04 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 34D6ED6E;
        Thu, 14 Jan 2021 10:10:19 -0800 (PST)
Received: from C02TD0UTHF1T.local (unknown [10.57.42.21])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CD44B3F70D;
        Thu, 14 Jan 2021 10:10:16 -0800 (PST)
Date:   Thu, 14 Jan 2021 18:10:13 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        Jiri Kosina <jikos@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>, linux-doc@vger.kernel.org,
        live-patching@vger.kernel.org
Subject: Re: [PATCH] Documentation: livepatch: document reliable stacktrace
Message-ID: <20210114181013.GE2739@C02TD0UTHF1T.local>
References: <20210113165743.3385-1-broonie@kernel.org>
 <20210113192735.rg2fxwlfrzueinci@treble>
 <20210113202315.GI4641@sirena.org.uk>
 <20210113222541.ysvtievx4o5r42ym@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210113222541.ysvtievx4o5r42ym@treble>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Jan 13, 2021 at 04:25:41PM -0600, Josh Poimboeuf wrote:
> On Wed, Jan 13, 2021 at 08:23:15PM +0000, Mark Brown wrote:
> > On Wed, Jan 13, 2021 at 01:33:13PM -0600, Josh Poimboeuf wrote:
> > 
> > > I think it's worth mentioning a little more about objtool.  There are a
> > > few passing mentions of objtool's generation of metadata (i.e. ORC), but
> > > objtool has another relevant purpose: stack validation.  That's
> > > particularly important when it comes to frame pointers.
> > 
> > > For some architectures like x86_64 and arm64 (but not powerpc/s390),
> > > it's far too easy for a human to write asm and/or inline asm which
> > > violates frame pointer protocol, silently causing the violater's callee
> > > to get skipped in the unwind.  Such architectures need objtool
> > > implemented for CONFIG_STACK_VALIDATION.
> > 
> > This basically boils down to just adding a statement saying "you may
> > need to depend on objtool" I think?
> 
> Right, but maybe it would be a short paragraph or two.

I reckon that's a top-level section between requirements and
consideration along the lines of:

3. Compile-time analysis
========================

To ensure that kernel code can be correctly unwound in all cases,
architectures may need to verify that code has been compiled in a manner
expected by the unwinder. For example, an unwinder may expect that
functions manipulate the stack pointer in a limited way, or that all
functions use specific prologue and epilogue sequences. Architectures
with such requirements should verify the kernel compilation using
objtool.

In some cases, an unwinder may require metadata to correctly unwind.
Where necessary, this metadata should be generated at build time using
objtool.

... perhaps elaborating a little further on the latter?

Thanks,
Mark.
