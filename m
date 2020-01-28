Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAE0314BC82
	for <lists+live-patching@lfdr.de>; Tue, 28 Jan 2020 16:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbgA1PAc (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 28 Jan 2020 10:00:32 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:52704 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726676AbgA1PAc (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 28 Jan 2020 10:00:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580223630;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UciBCe0URT2sDPatGmTOte5M9IpV1BmQHRNEHQ3YlSQ=;
        b=ZaSSm2k0MNjHcI17wmW8T51Ylq+mJqNksA2MPVfg2FVsBd2cezMDVhxnoNLIIyX/XxZEWf
        I0U04zwY4tEkfH0L/d038TQN96wVEExDcfgVMbzUaZKhZ/EY9zNEBcER8MSGn5W771E+6G
        nDBDQyM4U1RAd4rA3C+9dLksF7NpNsA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-165-eqD_xNQHPAmiQzXLd2hz_g-1; Tue, 28 Jan 2020 10:00:28 -0500
X-MC-Unique: eqD_xNQHPAmiQzXLd2hz_g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1236513F7;
        Tue, 28 Jan 2020 15:00:25 +0000 (UTC)
Received: from treble (ovpn-124-151.rdu2.redhat.com [10.10.124.151])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7904F1000337;
        Tue, 28 Jan 2020 15:00:16 +0000 (UTC)
Date:   Tue, 28 Jan 2020 09:00:14 -0600
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Miroslav Benes <mbenes@suse.cz>
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
Message-ID: <20200128150014.juaxfgivneiv6lje@treble>
References: <7e9c7dd1-809e-f130-26a3-3d3328477437@redhat.com>
 <20191015182705.1aeec284@gandalf.local.home>
 <20191016074217.GL2328@hirez.programming.kicks-ass.net>
 <20191021150549.bitgqifqk2tbd3aj@treble>
 <20200120165039.6hohicj5o52gdghu@treble>
 <alpine.LSU.2.21.2001210922060.6036@pobox.suse.cz>
 <20200121161045.dhihqibnpyrk2lsu@treble>
 <alpine.LSU.2.21.2001221052331.15957@pobox.suse.cz>
 <20200122214239.ivnebi7hiabi5tbs@treble>
 <alpine.LSU.2.21.2001281014280.14030@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.2001281014280.14030@pobox.suse.cz>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Jan 28, 2020 at 10:28:07AM +0100, Miroslav Benes wrote:
> I don't think we have something special at SUSE not generally available...
> 
> ...and I don't think it is really important to discuss that and replying 
> to the above, because there is a legitimate use case which relies on the 
> flag. We decided to support different use cases right at the beginning.
> 
> I understand it currently complicates things for objtool, but objtool is 
> sensitive to GCC code generation by definition. "Issues" appear with every 
> new GCC version. I see no difference here and luckily it is not so 
> difficult to fix it.
> 
> I am happy to help with acting on those objtool warning reports you 
> mentioned in the other email. Just Cc me where appropriate. We will take a 
> look.

As I said, the objtool warnings aren't even the main issue.

There are N users[*] of CONFIG_LIVEPATCH, where N is perhaps dozens.
For N-1 users, they have to suffer ALL the drawbacks, with NONE of the
benefits.

And, even if they wanted those benefits, they have no idea how to get
them because the patch creation process isn't documented.

And, there's no direct upstream usage of the flag, i.e. the only user
does so in a distro which can easily modify KCFLAGS in the spec file.

As best as I can tell, these are facts, which you seem to keep glossing
over.  Did I get any of the facts wrong?


[*] The term 'user' describes the creator/distributor of the
    live patches.

-- 
Josh

