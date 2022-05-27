Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE4A5365F8
	for <lists+live-patching@lfdr.de>; Fri, 27 May 2022 18:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354114AbiE0Q1s (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 27 May 2022 12:27:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232903AbiE0Q1q (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 27 May 2022 12:27:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D046B340F1;
        Fri, 27 May 2022 09:27:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8920AB824C9;
        Fri, 27 May 2022 16:27:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1C57C385A9;
        Fri, 27 May 2022 16:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653668863;
        bh=PRaPi35zkOUa2ee/LGAevmhlOaftEQU94uTYvSbtIYs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=AUdwYQFnQL+oIJZpQBq82jSSk/heA2LObEFqnWPTzgh2mrOIXni7GDPG92ZByPDAk
         CXin4Wfey4ZAbnSrcb4b9JF9zdlkzUnIJyGTlytzZNg9j35uWmSLNL0n6xTt1iHWX6
         GN5QE2cHwLcpHdl8DWmcaC6mP3HldR9n21UzSajhcjyB7DZ8b7ZNP81SzbRcaPyaK1
         otrfDC0N16l12UKtoxCh5N87Wq41JO+dF94S0HDlIXuHW93p74TPJNaWaYVXufzCts
         UNreNLMeRwR0EM7IHX0B9C9lArH3Anry9wqsz4BPdA9v+MFBr9rL8X0o5TOhCO2ktv
         bWLDU2W0wVVPA==
Message-ID: <459385ee7ccf4fcf3e22d4a11b4f438d648422bf.camel@kernel.org>
Subject: Re: [PATCH v7 03/25] kallsyms: increase maximum kernel symbol
 length to 512
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        David Howells <dhowells@redhat.com>
Cc:     Miguel Ojeda <ojeda@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        rust-for-linux <rust-for-linux@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Petr Mladek <pmladek@suse.com>,
        Alex Gaynor <alex.gaynor@gmail.com>,
        Wedson Almeida Filho <wedsonaf@google.com>,
        Gary Guo <gary@garyguo.net>, Boqun Feng <boqun.feng@gmail.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        live-patching@vger.kernel.org, linux-perf-users@vger.kernel.org
Date:   Fri, 27 May 2022 19:25:57 +0300
In-Reply-To: <CANiq72m6ttD9QpB3nW-5B+M1seknv0GZ4-DqtF85qTg6Lvxnhg@mail.gmail.com>
References: <20220523020209.11810-1-ojeda@kernel.org>
         <20220523020209.11810-4-ojeda@kernel.org> <YovvIQeN3lmOYzJO@kernel.org>
         <CANiq72m6ttD9QpB3nW-5B+M1seknv0GZ4-DqtF85qTg6Lvxnhg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.1 
MIME-Version: 1.0
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, 2022-05-24 at 20:07 +0200, Miguel Ojeda wrote:
> On Mon, May 23, 2022 at 10:33 PM Jarkko Sakkinen <jarkko@kernel.org> wrot=
e:
> >=20
> > There's no description what the patch does.
>=20
> I am not sure what you mean. Both the subject and the last paragraph
> describe what the patch does, while the rest gives the rationale
> behind it.
>=20
> Cheers,
> Miguel

The honest answer: I don't actually remember what I was thinking=C2=A0
(other stuff stole my focus) but my comment neither makes much
sense to me. Please just ignore it, and apologies for causing
confusion.

There's something I'm looking into in my spare time right now.
I'm experimenting with interfacing keyring types to Rust. The
first step, I guess, is to provide a Rust abstraction for
assoc_array.

I've skimmed through the patch set and have now *rough* idea of
patterns and techniques. My opens are more on the process side
of things since there's no yet mainline subtree.

If I send a patch or patch sets, would this be a good workflow:

1. RFC tag.
2. In the cover letter denote the patch set version, which was
   used the baseline.

Linux keyring is without argument a kind of subsystem that would
hugely benefit of the Rust work, as it is both user space facing=C2=A0
nd handling a vast amount of user's confidential data.=20

BR, Jarkko
