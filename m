Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EDC323B1D2
	for <lists+live-patching@lfdr.de>; Tue,  4 Aug 2020 02:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728012AbgHDAsd (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 3 Aug 2020 20:48:33 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23289 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726398AbgHDAsc (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 3 Aug 2020 20:48:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596502111;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pni1o6aoiUKtw/3OfYS97iO3vEt5WV4q/1D+eS1+IJs=;
        b=TcvSJ7XZ/BwwDWzS4tntOJEvnfaZtkSCUPTPJkAmfHFT++9BPmycVGyN3nmIFe3SLct4M8
        3uwmlQA2QBrcGl0d8SPUTsohfqnx1Diq7euCgY1GJO2k4n2kjKFM4MoktnObUHN2ujm3AP
        Hf9Jr0wZOcz6FTNntPbCqwTAttUfXvg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-228-Q5lytYKUP--GAurLnuzXlQ-1; Mon, 03 Aug 2020 20:48:27 -0400
X-MC-Unique: Q5lytYKUP--GAurLnuzXlQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C60F5100AA23;
        Tue,  4 Aug 2020 00:48:24 +0000 (UTC)
Received: from redhat.com (ovpn-112-64.phx2.redhat.com [10.3.112.64])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 32DEF5D9F7;
        Tue,  4 Aug 2020 00:48:21 +0000 (UTC)
Received: from fche by redhat.com with local (Exim 4.94)
        (envelope-from <fche@redhat.com>)
        id 1k2l7p-0008W3-HU; Mon, 03 Aug 2020 20:48:17 -0400
Date:   Mon, 3 Aug 2020 20:48:17 -0400
From:   "Frank Ch. Eigler" <fche@redhat.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Evgenii Shatokhin <eshatokhin@virtuozzo.com>,
        Kristen Carlson Accardi <kristen@linux.intel.com>,
        Miroslav Benes <mbenes@suse.cz>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, arjan@linux.intel.com,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        kernel-hardening@lists.openwall.com, rick.p.edgecombe@intel.com,
        live-patching@vger.kernel.org,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jessica Yu <jeyu@kernel.org>
Subject: Re: [PATCH v4 00/10] Function Granular KASLR
Message-ID: <20200804004817.GD30810@redhat.com>
References: <20200717170008.5949-1-kristen@linux.intel.com>
 <alpine.LSU.2.21.2007221122110.10163@pobox.suse.cz>
 <e9c4d88b-86db-47e9-4299-3fac45a7e3fd@virtuozzo.com>
 <202008031043.FE182E9@keescook>
 <fc6d2289-af97-5cf8-a4bb-77c2b0b8375c@redhat.com>
 <20200803193837.GB30810@redhat.com>
 <202008031310.4F8DAA20@keescook>
 <20200803211228.GC30810@redhat.com>
 <202008031439.F1399A588@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202008031439.F1399A588@keescook>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi -

> > We have relocated based on sections, not some subset of function
> > symbols accessible that way, partly because DWARF line- and DIE- based
> > probes can map to addresses some way away from function symbols, into
> > function interiors, or cloned/moved bits of optimized code.  It would
> > take some work to prove that function-symbol based heuristic
> > arithmetic would have just as much reach.
> 
> Interesting. Do you have an example handy? 

No, I'm afraid I don't have one that I know cannot possibly be
expressed by reference to a function symbol only.  I'd look at
systemtap (4.3) probe point lists like:

% stap -vL 'kernel.statement("*@kernel/*verif*.c:*")'
% stap -vL 'module("amdgpu").statement("*@*execution*.c:*")'

which give an impression of computed PC addresses.

> It seems like something like that would reference the enclosing
> section, which means we can't just leave them out of the sysfs
> list... (but if such things never happen in the function-sections,
> then we *can* remove them...)

I'm not sure we can easily prove they can never happen there.

- FChE

