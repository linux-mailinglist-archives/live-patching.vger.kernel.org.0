Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E94A123AD69
	for <lists+live-patching@lfdr.de>; Mon,  3 Aug 2020 21:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728174AbgHCTi6 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 3 Aug 2020 15:38:58 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:55716 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727813AbgHCTi5 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 3 Aug 2020 15:38:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596483536;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KwaJzAuhKp0eMDKUyFcMapFzk1bqmh48WPQrufCV124=;
        b=Zxj6K0XhuJdbuSpf0YCx6zwtDxGc0m8ijyP5CBbtiS+0GgsDRERyiRxlSpXZBcueTrg7BP
        hd7VFDFmuz7pIN6AIwq4aEy27a9IY+DTRVjTYudhOKtLCnDqOEhOV4dTxCW8pQoqlecgF1
        TTrbsFUb7m5aGJtQhMzYg4kRmXPnWCE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-403-POlseAWyM4uGgMhDrzYE7A-1; Mon, 03 Aug 2020 15:38:54 -0400
X-MC-Unique: POlseAWyM4uGgMhDrzYE7A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EB7B8106B24B;
        Mon,  3 Aug 2020 19:38:51 +0000 (UTC)
Received: from redhat.com (ovpn-112-64.phx2.redhat.com [10.3.112.64])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 985DA69319;
        Mon,  3 Aug 2020 19:38:41 +0000 (UTC)
Received: from fche by redhat.com with local (Exim 4.94)
        (envelope-from <fche@redhat.com>)
        id 1k2gI9-0008Bt-GP; Mon, 03 Aug 2020 15:38:37 -0400
Date:   Mon, 3 Aug 2020 15:38:37 -0400
From:   "Frank Ch. Eigler" <fche@redhat.com>
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     Kees Cook <keescook@chromium.org>,
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
Message-ID: <20200803193837.GB30810@redhat.com>
References: <20200717170008.5949-1-kristen@linux.intel.com>
 <alpine.LSU.2.21.2007221122110.10163@pobox.suse.cz>
 <e9c4d88b-86db-47e9-4299-3fac45a7e3fd@virtuozzo.com>
 <202008031043.FE182E9@keescook>
 <fc6d2289-af97-5cf8-a4bb-77c2b0b8375c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fc6d2289-af97-5cf8-a4bb-77c2b0b8375c@redhat.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi -

> > While this does seem to be the right solution for the extant problem, I
> > do want to take a moment and ask if the function sections need to be
> > exposed at all? What tools use this information, and do they just want
> > to see the bounds of the code region? (i.e. the start/end of all the
> > .text* sections) Perhaps .text.* could be excluded from the sysfs
> > section list?

> [[cc += FChE, see [0] for Evgenii's full mail ]]

Thanks!

> It looks like debugging tools like systemtap [1], gdb [2] and its
> add-symbol-file cmd, etc. peek at the /sys/module/<MOD>/section/ info.
> But yeah, it would be preferable if we didn't export a long sysfs
> representation if nobody actually needs it.

Systemtap needs to know base addresses of loaded text & data sections,
in order to perform relocation of probe point PCs and context data
addresses.  It uses /sys/module/...., kind of under protest, because
there seems to exist no MODULE_EXPORT'd API to get at that information
some other way.

- FChE

