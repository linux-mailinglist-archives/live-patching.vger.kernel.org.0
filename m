Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56563146585
	for <lists+live-patching@lfdr.de>; Thu, 23 Jan 2020 11:20:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726188AbgAWKUB convert rfc822-to-8bit (ORCPT
        <rfc822;lists+live-patching@lfdr.de>);
        Thu, 23 Jan 2020 05:20:01 -0500
Received: from mx2.suse.de ([195.135.220.15]:47678 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726099AbgAWKUB (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 23 Jan 2020 05:20:01 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
X-Amavis-Alert: BAD HEADER SECTION, Duplicate header field: "Cc"
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 71C22B1EE;
        Thu, 23 Jan 2020 10:19:59 +0000 (UTC)
From:   Martin Jambor <mjambor@suse.cz>
To:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Jessica Yu <jeyu@kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, mhiramat@kernel.org,
        bristot@redhat.com, jbaron@akamai.com,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        mingo@kernel.org, namit@vmware.com, hpa@zytor.com, luto@kernel.org,
        ard.biesheuvel@linaro.org, live-patching@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v3 5/6] x86/ftrace: Use text_poke()
In-Reply-To: <20200122220350.zvwyrkip5mvv6j7g@treble>
References: <20191015153120.GA21580@linux-8ccs> <7e9c7dd1-809e-f130-26a3-3d3328477437@redhat.com> <20191015182705.1aeec284@gandalf.local.home> <20191016074217.GL2328@hirez.programming.kicks-ass.net> <20191021150549.bitgqifqk2tbd3aj@treble> <20200120165039.6hohicj5o52gdghu@treble> <alpine.LSU.2.21.2001210922060.6036@pobox.suse.cz> <20200121161045.dhihqibnpyrk2lsu@treble> <alpine.LSU.2.21.2001221312030.15957@pobox.suse.cz> <alpine.LSU.2.21.2001221556160.15957@pobox.suse.cz> <20200122220350.zvwyrkip5mvv6j7g@treble>
User-Agent: Notmuch/0.29.3 (https://notmuchmail.org) Emacs/26.3 (x86_64-suse-linux-gnu)
Date:   Thu, 23 Jan 2020 11:19:58 +0100
Message-ID: <ri6d0baqxtd.fsf@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hello,

On Wed, Jan 22 2020, Josh Poimboeuf wrote:
> Global noreturns are already a pain today.  There's no way for objtool
> to know whether GCC considered a function to be noreturn,

You should be able to get a good idea with -Wsuggest-attribute=noreturn:

$ cat a.c
int __attribute__((noreturn)) my_abort (void)
{
  __builtin_abort ();
}

int foo (void)
{
  return my_abort ();
}

int bar (int flag)
{
  if (flag)
    foo ();
  return 4;
}

$ gcc -S -O2 -Wsuggest-attribute=noreturn a.c 
a.c: In function ‘foo’:
a.c:6:5: warning: function might be candidate for attribute ‘noreturn’ [-Wsuggest-attribute=noreturn]
    6 | int foo (void)
      |     ^~~

GCC 9 and newer even have -fdiagnostics-format=json if you are into that
kind of thing.

Hope this helps a little,

Martin

