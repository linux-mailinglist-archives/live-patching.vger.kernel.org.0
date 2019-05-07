Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3ACF1611F
	for <lists+live-patching@lfdr.de>; Tue,  7 May 2019 11:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726286AbfEGJic (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 7 May 2019 05:38:32 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:36487 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726072AbfEGJic (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 7 May 2019 05:38:32 -0400
Received: by mail-lj1-f196.google.com with SMTP id z1so1478748ljb.3;
        Tue, 07 May 2019 02:38:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Tc6IIAjzg9ip1EiDB2DwT04Nip0LdOfWWuVFTByFfgo=;
        b=UDognZTYXEUniKF86MKUW8+deTu3dwQfNsGJvCJW5jdCXBggyLyUuPIM1P62MEc7IC
         geaY9U+nG+LjyYH9PRrTmtunVmzCvoqdOsEWSbqSy8hdSlvXX6uPUqOf/Ucp0dXRCsb9
         qQBQnWxrM4Uj0N5AIT6UKedAFp2Q9Eeg2E1XyZk+LEca9MRdsJaWMqRE27lSQo7BFNKc
         rjXkrgTD1TzOG74F3Aguy+KzlZUl/qDUKi9Taj27YxdkrQYz6rC6vOe2YKyKd2q692/m
         sbNm/Ao4v2ExhfUpmiHiYFaOX2BJhOGuvsQ4CDj0XlHiFpw8dcCqn9NGFpHP4K7YSIsF
         IVzw==
X-Gm-Message-State: APjAAAUgLIPLvG2DTC8AOR/v/6Y7D77YK2yZcSMy5Fp5UAZ0eekKavav
        Q/GGvtKfMDXcUkWEngqbnws=
X-Google-Smtp-Source: APXvYqybeeeYP4hHflBw+LYg1ipaMT1I4IYHEpl2+FiWwNASLJPLex61menqwVWecLyO5n2BV7l1jA==
X-Received: by 2002:a2e:85d2:: with SMTP id h18mr16296224ljj.128.1557221910203;
        Tue, 07 May 2019 02:38:30 -0700 (PDT)
Received: from xi.terra (c-74bee655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.190.116])
        by smtp.gmail.com with ESMTPSA id z3sm3060282ljg.78.2019.05.07.02.38.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 May 2019 02:38:29 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.91)
        (envelope-from <johan@kernel.org>)
        id 1hNwYP-0007Of-Jw; Tue, 07 May 2019 11:38:29 +0200
Date:   Tue, 7 May 2019 11:38:29 +0200
From:   Johan Hovold <johan@kernel.org>
To:     "Tobin C. Harding" <me@tobin.cc>
Cc:     Johan Hovold <johan@kernel.org>,
        "Tobin C. Harding" <tobin@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 3/5] kobject: Fix kernel-doc comment first line
Message-ID: <20190507093829.GF4333@localhost>
References: <20190502023142.20139-1-tobin@kernel.org>
 <20190502023142.20139-4-tobin@kernel.org>
 <20190502073823.GQ26546@localhost>
 <20190502082539.GB18363@eros.localdomain>
 <20190502083922.GR26546@localhost>
 <20190503014015.GC7416@eros.localdomain>
 <20190503075607.GC26546@localhost>
 <20190506230035.GA29554@eros.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190506230035.GA29554@eros.localdomain>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, May 07, 2019 at 09:00:35AM +1000, Tobin C. Harding wrote:
> On Fri, May 03, 2019 at 09:56:07AM +0200, Johan Hovold wrote:

> > This isn't about any particular subsystem, but more the tendency of
> > people to make up random rules and try to to force it on others. It's
> > churn, and also makes things like code forensics and backports harder
> > for no good reason.
> 
> Points noted.
> 
> > Both capitalisation styles are about as common for the function
> > description judging from a quick grep, but only 10% or so use a full
> > stop ('.'). And forcing the use of sentence case and full stop for
> > things like
> > 
> > 	/**
> > 	 * maar_init() - Initialise MAARs.
> > 
> > or
> > 
> > 	* @instr: Operational instruction.
> > 
> > would be not just ugly, but wrong (as these are not independent
> > clauses).
> 
> You are correct here.

Actually, I may have been wrong about the first example (imperative),
but the second still stands.

> Thanks for taking the time to flesh out your argument Johan, I am now in
> agreement with you :)

Good to hear! :)

Johan
