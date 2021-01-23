Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6B403018C9
	for <lists+live-patching@lfdr.de>; Sun, 24 Jan 2021 00:01:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726355AbhAWXAR (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sat, 23 Jan 2021 18:00:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726291AbhAWXAO (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sat, 23 Jan 2021 18:00:14 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9A38C061786
        for <live-patching@vger.kernel.org>; Sat, 23 Jan 2021 14:59:33 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id e9so5383053plh.3
        for <live-patching@vger.kernel.org>; Sat, 23 Jan 2021 14:59:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XEmc28AGxg8G814HFx/ez3FIOIJ36RQOCl9rPqWgvnQ=;
        b=W4/1YIH5h1nwo0TQjLRQxWuhCqmWOmBpjcEApaJH7uj/3OwkPDFgVJw1I/zlOUvcJb
         KcKdWIT31OiX5BRomKzZVwrc2DGvjqmTzir9gKKP2oF7qxSIHrkr1iFvz2oY4G9txrSU
         zXbJWwWqYLma08LREe/nEyFp4fyJ6dkHkrC3kMaKauWs1HMmCcHtFaO0jFqeP8zEzmcb
         TlVnqkGVN2NPe4cJnyNGr2KsuysC9cDsqqIytYasLLXXICc9ahrXy6EDNFBgF1W46LsF
         a+QLYR5GdTOkwyj3I7rj004Oxb45fjcFqgU0UH9hFti1oZ1PkYN4MFP55HLQlblxsMUL
         3xKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XEmc28AGxg8G814HFx/ez3FIOIJ36RQOCl9rPqWgvnQ=;
        b=maGt3fiwv6CDqA9mJEZf+qW4VvQT/gEzGAQhF/RkthxYp0Ztw6VQeAb+1A3F7BuO9I
         1Z4xpj3bwOFdQLr0ghp7TLp19OlPYpCsvnF+ofcQP4Ll038NRMux/APEVtgW5yGstlRX
         3zonn4Hi3bfBF52E//2XGnGlXN6mBsYdUYyZSnNOaqPD1o86Fv1clxU9Ii+HI7bxLdKi
         d9N2q8fJ6PMFd0hkJ8SrUemxtRDmoSj4jLjDcrf+D+qsUMLJGJ0QcGkvpfRZtYm3V2dX
         c4ytxZgs/OM9huUBAX1+QmXM7gsKpSURpUv59+FiQL7OE3kz5KJzrn/9R+K3031VzWgR
         ltEw==
X-Gm-Message-State: AOAM532Tg6anbEY6T2X9EcbOTmoSGctEQR3naWFbpgrf0bmIVkSNhaRs
        rK5wbCJTIFKoITSS0vXapPW3Pg==
X-Google-Smtp-Source: ABdhPJwG/hyh/aI3nS1B02oCINgwBdGDzEKx4NdActW7UaoHoTBHvT62TjXIs9ZQdEA0bRmcdt0R6Q==
X-Received: by 2002:a17:90a:f998:: with SMTP id cq24mr13543739pjb.6.1611442772450;
        Sat, 23 Jan 2021 14:59:32 -0800 (PST)
Received: from google.com ([2620:15c:2ce:0:a6ae:11ff:fe11:4abb])
        by smtp.gmail.com with ESMTPSA id l14sm13144826pjy.15.2021.01.23.14.59.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Jan 2021 14:59:31 -0800 (PST)
Date:   Sat, 23 Jan 2021 14:59:28 -0800
From:   Fangrui Song <maskray@google.com>
To:     Kristen Carlson Accardi <kristen@linux.intel.com>
Cc:     Miroslav Benes <mbenes@suse.cz>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Kees Cook <keescook@chromium.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, arjan@linux.intel.com,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        kernel-hardening@lists.openwall.com, rick.p.edgecombe@intel.com,
        live-patching@vger.kernel.org, Hongjiu Lu <hongjiu.lu@intel.com>,
        joe.lawrence@redhat.com
Subject: Re: [PATCH v4 00/10] Function Granular KASLR
Message-ID: <20210123225928.z5hkmaw6qjs2gu5g@google.com>
References: <20200717170008.5949-1-kristen@linux.intel.com>
 <alpine.LSU.2.21.2007221122110.10163@pobox.suse.cz>
 <202007220738.72F26D2480@keescook>
 <20200722160730.cfhcj4eisglnzolr@treble>
 <202007221241.EBC2215A@keescook>
 <301c7fb7d22ad6ef97856b421873e32c2239d412.camel@linux.intel.com>
 <20200722213313.aetl3h5rkub6ktmw@treble>
 <46c49dec078cb8625a9c3a3cd1310a4de7ec760b.camel@linux.intel.com>
 <alpine.LSU.2.21.2008281216031.29208@pobox.suse.cz>
 <20200828192413.p6rctr42xtuh2c2e@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200828192413.p6rctr42xtuh2c2e@treble>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 2020-08-28, Josh Poimboeuf wrote:
>On Fri, Aug 28, 2020 at 12:21:13PM +0200, Miroslav Benes wrote:
>> > Hi there! I was trying to find a super easy way to address this, so I
>> > thought the best thing would be if there were a compiler or linker
>> > switch to just eliminate any duplicate symbols at compile time for
>> > vmlinux. I filed this question on the binutils bugzilla looking to see
>> > if there were existing flags that might do this, but H.J. Lu went ahead
>> > and created a new one "-z unique", that seems to do what we would need
>> > it to do.
>> >
>> > https://sourceware.org/bugzilla/show_bug.cgi?id=26391
>> >
>> > When I use this option, it renames any duplicate symbols with an
>> > extension - for example duplicatefunc.1 or duplicatefunc.2. You could
>> > either match on the full unique name of the specific binary you are
>> > trying to patch, or you match the base name and use the extension to
>> > determine original position. Do you think this solution would work?
>>
>> Yes, I think so (thanks, Joe, for testing!).
>>
>> It looks cleaner to me than the options above, but it may just be a matter
>> of taste. Anyway, I'd go with full name matching, because -z unique-symbol
>> would allow us to remove sympos altogether, which is appealing.
>>
>> > If
>> > so, I can modify livepatch to refuse to patch on duplicated symbols if
>> > CONFIG_FG_KASLR and when this option is merged into the tool chain I
>> > can add it to KBUILD_LDFLAGS when CONFIG_FG_KASLR and livepatching
>> > should work in all cases.
>>
>> Ok.
>>
>> Josh, Petr, would this work for you too?
>
>Sounds good to me.  Kristen, thanks for finding a solution!

(I am not subscribed. I came here via https://sourceware.org/bugzilla/show_bug.cgi?id=26391 (ld -z unique-symbol))

> This works great after randomization because it always receives the
> current address at runtime rather than relying on any kind of
> buildtime address. The issue with with the live-patching code's
> algorithm for resolving duplicate symbol names. If they request a
> symbol by name from the kernel and there are 3 symbols with the same
> name, they use the symbol's position in the built binary image to
> select the correct symbol.

If a.o, b.o and c.o define local symbol 'foo'.
By position, do you mean that

* the live-patching code uses something like (findall("foo")[0], findall("foo")[1], findall("foo")[2]) ?
* shuffling a.o/b.o/c.o will make the returned triple different

Local symbols are not required to be unique. Instead of patching the toolchain,
have you thought about making the live-patching code smarter?
(Depend on the duplicates, such a linker option can increase the link time/binary size considerably
AND I don't know in what other cases such an option will be useful)

For the following example, 

https://sourceware.org/bugzilla/show_bug.cgi?id=26822

   # RUN: split-file %s %t
   # RUN: gcc -c %t/a.s -o %t/a.o
   # RUN: gcc -c %t/b.s -o %t/b.o
   # RUN: gcc -c %t/c.s -o %t/c.o
   # RUN: ld-new %t/a.o %t/b.o %t/c.o -z unique-symbol -o %t.exe
   
   #--- a.s
   a: a.1: a.2: nop
   #--- b.s
   a: nop
   #--- c.s
   a: nop

readelf -Ws output:

Symbol table '.symtab' contains 13 entries:
    Num:    Value          Size Type    Bind   Vis      Ndx Name
      0: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT  UND 
      1: 0000000000000000     0 FILE    LOCAL  DEFAULT  ABS a.o
      2: 0000000000401000     0 NOTYPE  LOCAL  DEFAULT    1 a
      3: 0000000000401000     0 NOTYPE  LOCAL  DEFAULT    1 a.1
      4: 0000000000401000     0 NOTYPE  LOCAL  DEFAULT    1 a.2
      5: 0000000000000000     0 FILE    LOCAL  DEFAULT  ABS b.o
      6: 0000000000401001     0 NOTYPE  LOCAL  DEFAULT    1 a.1
      7: 0000000000000000     0 FILE    LOCAL  DEFAULT  ABS c.o
      8: 0000000000401002     0 NOTYPE  LOCAL  DEFAULT    1 a.2
      9: 0000000000000000     0 NOTYPE  GLOBAL DEFAULT  UND _start
     10: 0000000000402000     0 NOTYPE  GLOBAL DEFAULT    1 __bss_start
     11: 0000000000402000     0 NOTYPE  GLOBAL DEFAULT    1 _edata
     12: 0000000000402000     0 NOTYPE  GLOBAL DEFAULT    1 _end

Note that you have STT_FILE SHN_ABS symbols.
If the compiler does not produce them, they will be synthesized by GNU ld.

   https://sourceware.org/bugzilla/show_bug.cgi?id=26822
   ld.bfd copies non-STT_SECTION local symbols from input object files.  If an
   object file does not have STT_FILE symbols (no .file directive) but has
   non-STT_SECTION local symbols, ld.bfd synthesizes a STT_FILE symbol

The filenames are usually base names, so "a.o" and "a.o" in two directories will
be indistinguishable.  The live-patching code can possibly work around this by
not changing the relative order of the two "a.o".
