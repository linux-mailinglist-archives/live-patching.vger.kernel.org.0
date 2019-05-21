Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 373002561C
	for <lists+live-patching@lfdr.de>; Tue, 21 May 2019 18:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729116AbfEUQxX (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 21 May 2019 12:53:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:36744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727817AbfEUQxW (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 21 May 2019 12:53:22 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FFEB217F5;
        Tue, 21 May 2019 16:53:21 +0000 (UTC)
Date:   Tue, 21 May 2019 12:53:19 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Johannes Erdfelt <johannes@erdfelt.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Jessica Yu <jeyu@kernel.org>, Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Oops caused by race between livepatch and ftrace
Message-ID: <20190521125319.04ac8b6c@gandalf.local.home>
In-Reply-To: <20190521164227.bxdff77kq7fgl5lp@treble>
References: <20190520194915.GB1646@sventech.com>
        <90f78070-95ec-ce49-1641-19d061abecf4@redhat.com>
        <20190520210905.GC1646@sventech.com>
        <20190520211931.vokbqxkx5kb6k2bz@treble>
        <20190520173910.6da9ddaf@gandalf.local.home>
        <20190521141629.bmk5onsaab26qoaw@treble>
        <20190521104204.47d4e175@gandalf.local.home>
        <20190521164227.bxdff77kq7fgl5lp@treble>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, 21 May 2019 11:42:27 -0500
Josh Poimboeuf <jpoimboe@redhat.com> wrote:

> Hm.  I suppose using ftrace_lock might be less risky since that lock is
> only used internally by ftrace (up until now).  But I think it would
> also make less sense because the text_mutex is supposed to protect code
> patching.  And presumably ftrace_lock is supposed to be ftrace-specific.
> 
> Here's the latest patch, still using text_mutex.  I added some lockdep
> assertions to ensure the permissions toggling functions are always
> called with text_mutex.  It's running through 0-day right now.  I can
> try to run it through various tests with CONFIG_LOCKDEP.

Yeah, text_mutex probably does make more sense. ftrace_mutex was around
before text_mutex as ftrace was the first one to do the runtime
patching (after boot has finished). It wasn't until we introduced
text_poke that we decided to create the text_mutex locking as well.

> 
> 
> From: Josh Poimboeuf <jpoimboe@redhat.com>
> Subject: [PATCH] livepatch: Fix ftrace module text permissions race

Thanks,

I'll try to find some time to test this as well.

-- Steve
